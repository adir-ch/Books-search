package Compare;

import javax.xml.parsers.DocumentBuilder; 
import javax.xml.parsers.DocumentBuilderFactory;  
import javax.xml.parsers.FactoryConfigurationError;  
import javax.xml.parsers.ParserConfigurationException;
 
import org.xml.sax.SAXException;  
import org.xml.sax.SAXParseException;  

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Hashtable;


import org.w3c.dom.Document;
import org.w3c.dom.DOMException;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ConfigurationFile {

    private Document document;
    private Hashtable leafsData;
    private boolean isFound;
    private String result;

    public ConfigurationFile() {
        leafsData = new Hashtable();        
        this.isFound = false;
    }
    
    public void init (String file)
    {
        // Creating a new document builder 
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        
        // Setting parsing instractions 
        factory.setValidating(false);   
        factory.setNamespaceAware(false);
        factory.setIgnoringComments(true);
        factory.setCoalescing(false);
        factory.setIgnoringElementContentWhitespace(true);
                
        try 
        {
           // parsing XML file 
           DocumentBuilder builder = factory.newDocumentBuilder();
           this.document = builder.parse(ConfigurationFile.class.getResourceAsStream(file));
           this.getLeafsData(this.document.getChildNodes());
        }         
        catch (SAXException sxe) {
            // Error generated during parsing)
            Exception  x = sxe;
            if (sxe.getException() != null)
                x = sxe.getException();
            x.printStackTrace();
        } 
        catch (ParserConfigurationException pce) {
            // Parser with specified options can't be built
            pce.printStackTrace();
        } 
        catch (IOException ioe) {
           // I/O error
           ioe.printStackTrace();
        }
    }
    
    private boolean isLeaf(Node node)
    {
        if ( node.getNodeType() == 4 || !node.hasChildNodes() && node.getNodeValue() != null)
            return true;
        return false;
    }
    
    public void printTreeLeafs()
    {
        this.printLeafs(this.document.getChildNodes());
    }
    
    private void printLeafs(NodeList list)
    {
        if (list != null)
            for (int i = 0; i < list.getLength(); i++) 
            {
                if (this.isLeaf(list.item(i)))
                    System.out.println(list.item(i).getParentNode().getNodeName() + "=" + list.item(i).getNodeValue() + "**");
                this.printLeafs(list.item(i).getChildNodes());
            }
    }
       
    private void getLeafsData(NodeList list)
    {
         if (list != null)
            for (int i = 0; i < list.getLength(); i++) 
            {
                if (this.isLeaf(list.item(i)))
                    this.leafsData.put(list.item(i).getParentNode().getNodeName(), list.item(i).getNodeValue());
                this.getLeafsData(list.item(i).getChildNodes());
            }
    }
    
 
    private String search(NodeList list, String key)
    {
        if (list != null)
            for (int i = 0; (i < list.getLength()) && (this.isFound == false) ; i++) 
            {
                if (this.isLeaf(list.item(i)))
                {
                    if ((list.item(i).getParentNode().getNodeName()).equalsIgnoreCase(key))
                    {
                        this.isFound = true;
                        this.result = (String) list.item(i).getNodeValue();
                    }
                }
                else if(this.isFound == false) 
                    this.result = this.search(list.item(i).getChildNodes(), key);
            }
        return this.result;
    }
    
    
    public String get(String key) 
    {
        this.isFound = false;
        this.result = null;
        String data = this.search(this.document.getChildNodes(), key);
        if (data == null)
            return "";
        else
            return data;
    }
    
    public String getFromTable(String key)
    {
        return (String)this.leafsData.get(key);
    }   
}
