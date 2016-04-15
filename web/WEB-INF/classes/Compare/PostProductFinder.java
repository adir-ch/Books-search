package Compare;

import java.util.*;
import java.io.*;
import java.net.*;

public class PostProductFinder extends AbstractProductFinder
{
    private String searchAddress;
    public PostProductFinder(ArrayList results, ConfigurationFile searchProp)
    {
        super(results, searchProp);
        this.searchAddress = (String)this.searchProperties.get("Address-String");
    }
  
    protected InputStream getResponseStream() throws IOException 
    { 
        if ( this.searchType)
            this.searchRequest = (String)this.searchProperties.get("Query-string");
        else 
            this.searchRequest = (String)this.searchProperties.get("Search-string-writer");
        
        InputStream in = null;
        URLConnection con = null;
        URL url = null;
        String newLocation;
        
        // Connecting to the web site
        try 
        {
            url = new URL(this.searchAddress);
            con = url.openConnection();
            con.setDoInput(true);
            con.setDoOutput(true);
            con.setUseCaches(false);
            con.connect(); 
            
            PrintWriter out = new PrintWriter(con.getOutputStream());
            out.println(this.searchRequest + this.searchQuery);
            out.close();
        }
        catch (Exception ue)
        {
            System.out.println(ue.toString());
        }
        
        // Retriving web site stream
        try
        {
            if ((newLocation = con.getHeaderField("Location")) != null)
                in = new URL (url, newLocation).openStream();
            else 
                in=con.getInputStream(); 
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        return in;
     }
}
