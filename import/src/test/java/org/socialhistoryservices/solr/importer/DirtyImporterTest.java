/*
 * OAI4Solr exposes your Solr indexes using an OAI2 protocol handler.
 *
 *     Copyright (C) 2011  International Institute of Social History
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.socialhistoryservices.solr.importer;

import org.junit.Ignore;
import org.junit.Test;

import java.io.File;

@Ignore
public class DirtyImporterTest {

    @Test
    public void ImportSomeDate() throws Exception {

        String url = "http://localhost:8080/solr/all/update";
        String xslt = "C:\\Users\\lwo\\projects\\org.socialhistory.api\\solr-mappings\\solr\\all\\conf\\import\\add.xsl";
        String parameters = "collectionName:iish.evergreen.biblio";
        DirtyImporter importer = new DirtyImporter(url, xslt, parameters);
        File file = new File("C:\\data\\datasets\\iish.evergreen.biblio.xml") ;
        importer.process(file);
    }
}
