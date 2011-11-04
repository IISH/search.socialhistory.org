package org.iish;

import org.apache.log4j.Logger;
import org.marc4j.marc.DataField;
import org.marc4j.marc.Record;
import org.marc4j.marc.Subfield;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: lwo
 * Date: 7/12/11
 * Time: 6:36 PM
 * To change this template use File | Settings | File Templates.
 */
public class ImportBash {

    // define the base level indexer so that its methods can be called from the script.
// note that the SolrIndexer code will set this value before the script methods are called.
    org.solrmarc.index.SolrIndexer indexer = null;
    protected Logger logger = Logger.getLogger(this.getClass().getName());


    public Set getFormat(Record record) {

        final String SE = "Serials";
        final String BK = "Books and brochures";
        final String MU = "Music and sound";
        final String DO = "Documentation";
        final String AM = "Archives";
        final String VM = "Visual documents";
        final String OT = "Other";
        final Set result = new LinkedHashSet();

        String leader = record.getLeader().toString();

        // example leader
        // 00427nam a22001330a 45a0

        String format = leader.substring(6, 8).toLowerCase();
        if (format.equals("ar") || format.equals("as") || format.equals("ps") || format.equals("ar"))
            result.add(SE);
        if (format.equals("am") || format.equals("pm"))
            result.add(BK);
        if (format.equals("im") || format.equals("pi") || format.equals("ic"))
            result.add(MU);
        if (format.equals("do") || format.equals("oc"))
            result.add(DO);
        if (format.equals("bm") || format.equals("pc"))
            result.add(AM);
        if (format.equals("av") || format.equals("rm") || format.equals("gm") || format.equals("pv") || format.equals("km") || format.equals("kc"))
            result.add(VM);
        if (result.isEmpty())
            result.add(OT);

        return result;
    }

    public String getRecordType(Record record) {

        // AudioVideo ?
        List fields = record.getVariableFields("852");
        if (fields != null) {
            Iterator fieldsIter = fields.iterator();
            DataField physical;
            while (fieldsIter.hasNext()) {

                physical = (DataField) fieldsIter.next();
                List subfields = physical.getSubfields('p');
                if (subfields != null) {
                    Iterator subfieldsIter = subfields.iterator();
                    String desc;
                    while (subfieldsIter.hasNext()) {
                        desc = ((Subfield) subfieldsIter.next()).getData().toLowerCase();
                        if (desc.contains("10622/")) {
                            return "av";
                        }
                    }
                }
            }
        }

        return "marc";
    }

    /**
     * Determine Collection: from the 852c
     *
     * @return String     type of collection
     */
    public String getCollection(Record record) {

        List fields = record.getVariableFields("852");
        if (fields != null) {
            Iterator fieldsIter = fields.iterator();
            while (fieldsIter.hasNext()) {

                DataField physical = (DataField) fieldsIter.next();
                List subfields = physical.getSubfields('c');
                if (subfields != null) {
                    Subfield subfield = (Subfield) subfields.get(0);
                    return subfield.getData();
                }
            }
        }
        return "IISH";
    }

    /**
     * Determine Building\depot: "Catalog" or "Audio\visual"
     *
     * @return String     type of collection
     */
    public String getBuilding(Record record) {

        String recordType = getRecordType(record);
        if (recordType.equals("av"))
            return "Digital repository";

        return "Catalog";
    }

    public String getAllSearchableFields(Record record, String fieldSpec) throws Exception {

        String url = indexer.getFirstFieldVal(record, fieldSpec);
        String id = indexer.getFirstFieldVal(record, "001");
        if (url == null)
            return " ";
        Document document = loadDocument(url, id);
        return getText(document);
    }

    public String getAllSearchableFields(Record record, String lowerBoundStr, String upperBoundStr) {

        return indexer.getAllSearchableFields(record, lowerBoundStr, upperBoundStr);
    }

    private Document loadDocument(String url, String id) throws Exception {

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setIgnoringComments(true);
        dbf.setNamespaceAware(true);
        dbf.setValidating(false);
        DocumentBuilder db = dbf.newDocumentBuilder();

        final String vufind_home = System.getenv().get("VUFIND_HOME");
        String folder = vufind_home + File.separatorChar + "web" + File.separatorChar + "cache" + File.separatorChar;
        File f = new File(folder);
        if (!f.exists())
            f.mkdirs();
        File file = new File(folder + id + ".xml");
        Document document;
        if (file.exists())
            document = db.parse(file);
        else {
            document = db.parse(url.replace("api.iisg.nl", "api.iisg.nl:8080")); // ToDo: remove in production

            // And cache
            saveDocument(document, file);
        }

        return document;
    }

    private void saveDocument(Document document, File file) throws Exception {
        TransformerFactory transformerFactory =
                TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        DOMSource source = new DOMSource(document);
        StreamResult result = new StreamResult(file);
        transformer.transform(source, result);
    }

    private String getText(Document document) throws XPathExpressionException {
        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();
        final javax.xml.xpath.XPathExpression expr = xpath.compile("//@TEXT | //text()");
        final NodeList nodelist = (NodeList) expr.evaluate(document.getDocumentElement(), XPathConstants.NODESET);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < nodelist.getLength(); i++) {
            sb.append(nodelist.item(i).getTextContent().trim());
            sb.append(" ");
        }
        return sb.toString();
    }

    public String getTOC(Record record, String fieldSpec, String schema) throws Exception {

        String url = indexer.getFirstFieldVal(record, fieldSpec);
        String id = indexer.getFirstFieldVal(record, "001");
        return getTOC(url, id, schema);
    }

    private String getTOC(String url, String id, String schema) throws Exception {

        Document document = loadDocument(url, id);
        final String vufind_home = System.getenv().get("VUFIND_HOME");
        String stylesheet = vufind_home + File.separatorChar + "import" + File.separatorChar + "xsl" +
                File.separatorChar + schema;
        String data = getData(document, stylesheet).trim();
        return (data.length() == 0)
                ? null
                : data;
    }

    private String getData(Document document, String stylesheet) throws Exception {

        File file = new File(stylesheet);
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        final Source xslSource = new StreamSource(file);
        xslSource.setSystemId(file.toURI().toURL().toString());
        final Transformer transformer = transformerFactory.newTransformer(xslSource);
        DOMSource source = new DOMSource(document);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        StreamResult result = new StreamResult(outputStream);
        transformer.transform(source, result);
        return new String(outputStream.toByteArray(), "utf-8");
    }

    public String getFirstLetter(Record record, String fieldSpec) {

        String val = indexer.getFirstFieldVal(record, fieldSpec);
        if (val == null)
            return " ";
        try {
            return getFirstLetter(val);
        } catch (Exception e) {
            return " ";
        }
    }

    private String getFirstLetter(String val) {

        final String articles = "A AN DE HET EEN LE LA LES DEM DER DEM DAS 'T L'";
        final String text = val.toUpperCase();
        String[] split = text.split(" ", 4);
        int index = 0;
        for (String article : split) {
            if (!articles.contains(article + " "))
                break;
            index += article.length() + 1;
        }
        if (index > text.length())
            index = 0;
        return text.substring(index, index + 1);
    }

    public String getCollector(Record record) {

        final String[] fieldSpecs = new String[]{"700", "710", "711"};
        final List datafields = record.getVariableFields(fieldSpecs);
        Iterator fieldsIter = datafields.iterator();
        while (fieldsIter.hasNext()) {
            DataField datafield = (DataField) fieldsIter.next();
            Subfield subfield_a = datafield.getSubfield('a');
            Subfield subfield_e = datafield.getSubfield('e');
            if (subfield_a != null && subfield_e != null && subfield_e.getData().equals("collector")) {
                return subfield_a.getData();
            }
        }
        return null;
    }

    public String getCollectorA(Record record) {

        final List result = new ArrayList();
        final String[] fieldSpecs = new String[]{"700", "710", "711"};
        final List datafields = record.getVariableFields(fieldSpecs);
        Iterator fieldsIter = datafields.iterator();
        while (fieldsIter.hasNext()) {
            DataField datafield = (DataField) fieldsIter.next();
            Subfield subfield_a = datafield.getSubfield('a');
            Subfield subfield_e = datafield.getSubfield('e');
            if (subfield_a != null && subfield_e != null && subfield_e.getData().equals("collector")) {
                result.add(subfield_a.getData());
            }
        }

        if (result.size() == 0)
            return null;
        else return result.get(0) + "...";
    }
}
