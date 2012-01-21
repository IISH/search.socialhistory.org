package org.socialhistoryservices.solr.importer;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.ByteArrayRequestEntity;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.RequestEntity;
import org.apache.log4j.Logger;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.*;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;


/**
 * Mass import of files into the index
 * <p/>
 * args:
 * 0=folder containing files;
 * 1=SOLR update url with core, like http://localhost:8080/solr/all/update
 * 2=comma separated xslt stylesheets; 3=xslt parameters
 */
public class DirtyImporter {

    private String url;
    private List<Transformer> tChain;
    private int counter = 0;
    private long numMillisecondsToSleep = 15000; // 15 seconds

    public DirtyImporter(String url, String _xslts, String _parameters) throws TransformerConfigurationException, FileNotFoundException, MalformedURLException {

        this.url = url;
        String[] parameters = _parameters.split(",|;");
        String[] xslts = _xslts.split(",|;");
        tChain = new ArrayList<Transformer>(xslts.length + 1);
        final TransformerFactory tf = TransformerFactory.newInstance();
        tChain.add(tf.newTransformer());     // Identity template.

        for (String xslt : xslts) {
            File file = new File(xslt);
            Source source = new StreamSource(file);
            final Transformer t = tf.newTransformer(source);
            for (String parameter : parameters) {
                String[] split = parameter.split(":");
                t.setParameter(split[0], split[1]);
            }
            tChain.add(t);
        }
    }

    public void process(File file) throws FileNotFoundException, XMLStreamException {

        final XMLInputFactory xif = XMLInputFactory.newInstance();
        FileInputStream inputStream = new FileInputStream(file);
        final XMLStreamReader xsr = xif.createXMLStreamReader(inputStream, "utf-8");

        while (xsr.hasNext()) {
            xsr.next();
            if (xsr.getEventType() == XMLStreamReader.START_ELEMENT) {
                String elementName = xsr.getLocalName();
                if ("record".equals(elementName)) {
                    try {
                        process(xsr);
                    } catch (Exception e) {
                        log.warn(e);
                    }
                }
            }
        }
    }

    private void process(XMLStreamReader xsr) throws TransformerException, IOException {
        byte[] record = getRecordAsBytes(xsr);
        String resource = null;
        for (int i = 1; i < tChain.size(); i++) {
            if (i == tChain.size() - 2) {
                resource = new String(record, "utf-8");
            } else if (i == tChain.size() - 1) {
                tChain.get(i).setParameter("resource", resource);
            }
            record = convertRecord(tChain.get(i), record);
        }
        sendSolrDocument(record);
    }

    private void sendSolrDocument(byte[] record) throws IOException {

        final PostMethod post = new PostMethod(url);
        final RequestEntity entity = new ByteArrayRequestEntity(record, "text/xml; charset=utf-8");
        post.setRequestEntity(entity);
        final HttpClient httpclient = new HttpClient();
        log.info("Sending " + ++counter);
        try {
            httpclient.executeMethod(post);
        } catch (Exception e) {
            log.warn(e);
        } finally {
            post.releaseConnection();
        }

        if (counter % 1000 == 1) {
            log.info("Pause");
            sleep();
        }

    }

    /**
     * We give ourselves a breather for the socket connections to expire
     */
    private void sleep() {
        try {
            Thread.sleep(numMillisecondsToSleep);
        } catch (InterruptedException e) {
            log.warn(e);
        }
    }

    private byte[] convertRecord(Transformer transformer, byte[] record) throws TransformerException {

        final StreamSource source = new StreamSource(new ByteArrayInputStream(record));
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(source, new StreamResult(baos));
        return baos.toByteArray();
    }

    private byte[] getRecordAsBytes(XMLStreamReader xsr) throws TransformerException {
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        tChain.get(0).transform(new StAXSource(xsr), new StreamResult(baos));
        return baos.toByteArray();
    }

    public static void main(String[] args) throws Exception {

        File file = new File(args[0]);
        if (!file.exists() || file.isDirectory()) {
            System.err.println("File not found.");
            System.exit(1);
        }

        final String url = args[1];
        final String xslt = args[2];
        final String parameters = args[3];

        DirtyImporter importer = new DirtyImporter(url, xslt, parameters);
        importer.process(file);
    }

    private Logger log = Logger.getLogger(getClass().getName());
}