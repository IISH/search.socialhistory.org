package org.iish;


public class TestRecord {

    /*@Test
    public void getCollector() {

        final MarcFactory factory = MarcFactory.newInstance();
        final Record record = factory.newRecord();
        insertFields(factory, record, "700", "Collector 1");
        insertFields(factory, record, "710", "Collector 2");
        ImportBash bash = new ImportBash();
        final String result = bash.getCollector(record);
        Assert.assertNotNull(result);
    }

    private void insertFields(MarcFactory factory, Record record, String tag, String collector) {

        final DataField dataField = factory.newDataField(tag, ' ', ' ');
        final Subfield subField_a = factory.newSubfield('a', collector);
        final Subfield subField_e = factory.newSubfield('e', "collector");
        dataField.addSubfield(subField_a);
        dataField.addSubfield(subField_e);
        record.addVariableField(dataField);
    }*/
}
