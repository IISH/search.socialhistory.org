package org.iish;

public class TestCollate {

    public static void main(String[] args) {

        long oneWeek = 7 * 24 * 3600;
        args = new String[]{"C:\\mnt\\iish.evergreen.2\\", "C:\\mnt\\iish.evergreen.2.xml", String.valueOf(oneWeek)};

        try {
            Collate.main(args);
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }
}
