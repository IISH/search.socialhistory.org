package org.socialhistoryservices.solr.importer;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.util.Date;

/**
 * Collate
 * <p/>
 * Collates all Marc xml files into one catalog document.
 */
public class Collate {

    Transformer transformer;
    //long filter;
    private boolean delete;

    public Collate() throws TransformerConfigurationException {

        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        final InputStream resourceAsStream = this.getClass().getResourceAsStream("/marc.xsl");
        transformer = transformerFactory.newTransformer(new StreamSource(resourceAsStream));
        transformer.setOutputProperty("omit-xml-declaration", "yes");
    }

    private void process(String source, String target) throws IOException {

        final FileOutputStream fos = new FileOutputStream(target);
        final OutputStreamWriter writer = new OutputStreamWriter(fos, "utf8");
        writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        writer.write("<marc:catalog xmlns:marc=\"http://www.loc.gov/MARC21/slim\">");
        getFiles(new File(source), writer);
        writer.write("</marc:catalog>");
        writer.flush();
        fos.close();
    }

    private void getFiles(File folder, OutputStreamWriter writer) {

        final File[] files = folder.listFiles();
        for (File file : files) {
            if (file.isDirectory())
                getFiles(file, writer);
            else {
                try {
                    //final long time = Long.parseLong(file.getName().split("_")[0]);
                    //if (time > filter) {
                    final Document document = loadDocument(file);
                    if (document.getDocumentElement().hasChildNodes()) {
                        saveDocument(document, writer);
                    }
                    //}
                } catch (Exception e) {
                    e.printStackTrace();
                }
                try {
                } catch (Exception e) {
                    if (delete) {
                        file.delete();
                    }
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
        /*collate.filter = (args.length > 2)
                ? new Date().getTime() / 1000 - Long.parseLong(args[2])
                : 0;*/
        collate.delete = (args.length > 2)
                ? Boolean.valueOf(args[2])
                : false;
        collate.process(args[0], args[1]);
    }
}
