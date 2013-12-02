package Compare;

import java.util.*;
import java.io.*;
import java.net.*;

public class GetProductFinder extends AbstractProductFinder
{
    public GetProductFinder(ArrayList results, ConfigurationFile searchProp)
    {
        super(results, searchProp);
    }
  
    protected InputStream getResponseStream() throws IOException
    { 
         if (this.searchType)
            this.searchRequest = (String)this.searchProperties.get("Search-string");
         else 
            this.searchRequest = (String)this.searchProperties.get("Search-string-writer");
         
        InputStream in = null;
        URLConnection con = null;
        
        // Connecting to the web site
        try 
        {
            URL url = new URL(this.searchRequest + this.searchQuery);
            con = url.openConnection();
            con.setDoInput(true);
            con.setDoOutput(true);
            con.setUseCaches(false);
            con.connect(); 
        }
        catch (Exception ue)
        {
            System.out.println(ue.toString());
        }
        
        // Retriving web site stream
        try
        {
            in=con.getInputStream();       
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        return in;
     }
}
