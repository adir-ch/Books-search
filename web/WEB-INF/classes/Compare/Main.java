package Compare;

import java.util.*;
import java.io.*;
import java.net.*;

public class Main 
{
    public static void main(String[] args) throws Exception
    {
        /* // proxy settings 
        System.getProperties().put("proxyset", "true");
        System.getProperties().put("proxyHost", "192.168.2.254");
        System.getProperties().put("proxyPort", "8080");
        */
        
        Hashtable ht = new Hashtable();
        ht.put("Bakbook", "false");
        ht.put("Bookme", "true");
        ht.put("Booksrus", "false");
        ht.put("Top-10", "false");
        ht.put("Books4sale", "false");
        //String query = getQuary(args);
        
        SearchManager sm = new SearchManager();
        ProductInfo[] searchResults = sm.search("bible", ht, true);
        for (int i=0; i<searchResults.length; i++)
           System.out.println((searchResults[i]).toString());
        
    }
    public static String getQuary(String[] args) throws java.io.IOException
    {
        String line;
        if (args.length == 0)
        {
            java.io.BufferedReader in = new java.io.BufferedReader (new java.io.InputStreamReader ( System.in ) );
            System.out.println("Enter a search quary: ");
            line = in.readLine();
            return URLEncoder.encode(line,"ISO8859_8");
        }
        else 
        {
            StringBuffer buf = new StringBuffer();
            for ( int i=0; i<args.length ; i++)
                buf.append(args[i] + " ");
            return URLEncoder.encode(buf.toString(),"ISO8859_8");
        }
        
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
