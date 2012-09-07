package org.socialhistoryservices.solr.importer;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;

/**
 * Collate
 * <p/>
 * If the file parameter is a directory: collates Marc xml documents on fs into one catalog document.
 * If the file parameter is a file: collates all marc references into a catalog documnet.
 * <p/>
 * In both cases xslt an be applied.
 */
public class Collate {

    Transformer transformer;
    public int counter = 0;
    public int errors = 0;

    public Collate() throws TransformerConfigurationException {

        String xslt = System.getProperty("xsl");
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        if (xslt == null) {
            transformer = transformerFactory.newTransformer();
        } else {
            System.out.println("Using stylesheet -Dxsl=" + xslt);
            final InputStream resourceAsStream = this.getClass().getResourceAsStream("/" + xslt + ".xsl");
            transformer = transformerFactory.newTransformer(new StreamSource(resourceAsStream));
        }
        transformer.setOutputProperty("omit-xml-declaration", "yes");
    }

    private void process(String source, String target) throws IOException, XMLStreamException, TransformerException {

        final FileOutputStream fos = new FileOutputStream(target);
        final OutputStreamWriter writer = new OutputStreamWriter(fos, "utf8");
        writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        writer.write("<marc:catalog xmlns:marc=\"http://www.loc.gov/MARC21/slim\">");

        final File sourceFile = new File(source);
        assert sourceFile.exists();
        if (sourceFile.isDirectory()) {
            getFiles(sourceFile, writer);
        } else {
            getCatalog(sourceFile, writer);
        }
        writer.write("</marc:catalog>");
        writer.flush();
        fos.close();
    }

    private void getCatalog(File file, OutputStreamWriter writer) throws IOException, XMLStreamException, TransformerException {
        final XMLInputFactory xif = XMLInputFactory.newInstance();
        final XMLStreamReader xsr = xif.createXMLStreamReader(new FileReader(file));

        while (xsr.hasNext()) {
            if (xsr.getEventType() == XMLStreamReader.START_ELEMENT) {
                if (xsr.getLocalName().equals("record")) {
                    transformer.transform(new StAXSource(xsr), new StreamResult(writer));
                    writer.write("\r\n");
                    counter++;
                } else {
                    xsr.next();
                }
            } else {
                xsr.next();
            }
        }
        xsr.close();
    }

    private void getFiles(File folder, OutputStreamWriter writer) {

        final File[] files = folder.listFiles();
        for (File file : files) {
            if (file.isDirectory())
                getFiles(file, writer);
            else {
                try {
                    final Document document = loadDocument(file);
                    if (document.getDocumentElement().hasChildNodes()) {
                        saveDocument(document, writer);
                        writer.write("\r\n");
                        counter++;
                    }
                } catch (Exception e) {
                    errors++;
                    e.printStackTrace();
                }
            }
        }
    }

    private Document loadDocument(File file) throws ParserConfigurationException, IOException, SAXException {

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setIgnoringComments(true);
        dbf.setNamespaceAware(true);
        dbf.setValidating(false);
        DocumentBuilder db = dbf.newDocumentBuilder();
        return db.parse(file);
    }

    private void saveDocument(Document document, Writer writer) throws TransformerException {

        DOMSource source = new DOMSource(document);
        StreamResult result = new StreamResult(writer);
        transformer.transform(source, result);
    }

    /**
     * @param args args[0]=source folder; args[1] target document; optional filter args[2]=offset in seconds
     */
    public static void main(String[] args) throws Exception {

        Collate collate = new Collate();
        collate.process(args[0], args[1]);
        System.out.println();
        System.out.println("Records collated: " + collate.counter);
        System.out.println("Rejects: " + collate.errors);
    }
}
