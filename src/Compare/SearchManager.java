package Compare;

import java.net.*;
import java.util.*;
import java.io.*;
import java.net.*;

public class SearchManager
{
    ArrayList finders = new ArrayList();
    ArrayList results = new ArrayList();
    ArrayList searchProperties = new ArrayList();
 
    public SearchManager()
    {
        String file = null;
        ConfigurationFile cfg = new ConfigurationFile();
        try   
        {
            String configFilesDB = "configFiles.txt";
            InputStream in = SearchManager.class.getResourceAsStream(configFilesDB);
            BufferedReader reader = new BufferedReader (new InputStreamReader(in));
            while ((file = reader.readLine()) != null)
                if( ((char)file.charAt(0)) != '#')
                    this.analizeConfigFile(file);  
            System.out.println("Finders finished seccessfuly");
        }
        catch (Exception e)
        {
            System.out.println("##### Problem with " + file + " configuration file #####");
            System.out.println(e.toString());
        }
    }
    
    private void analizeConfigFile(String file) throws Exception
    {	
        ConfigurationFile cfgFile = new ConfigurationFile();
        cfgFile.init(file);
        try {
            String searchMethod = cfgFile.get("method");
            if(searchMethod.equalsIgnoreCase("get"))
                this.finders.add(new GetProductFinder(this.results, cfgFile));
            else if(searchMethod.equalsIgnoreCase("post"))
                   this.finders.add(new PostProductFinder(this.results, cfgFile));
            else 
                System.out.println("Your Config file: " + file + " is configured incorrectly");
        }
        catch (Exception exc) {
            System.out.println("Exc in building finder: " + file);
        }
    }
   
    public String[] getSupportedSites()
    {
        String[] sites = new String[this.finders.size()];
        for (int i=0; i < this.finders.size(); i++)
            sites[i] = ((ProductFinder)finders.get(i)).getFinderName();
        return sites;
    }
    
    public ProductInfo[] search (String query, Hashtable ht, boolean type) throws Exception
    {
        String encodedQuery = URLEncoder.encode(query,"ISO8859_8");
        this.results.clear();
        Vector sites = new Vector();
        String finderName;
        for (int i=0; i < this.finders.size(); i++)
        {
            finderName = ((ProductFinder)finders.get(i)).getFinderName();
            if (((String)ht.get(finderName)).equals("true"))
                sites.add(this.finders.get(i));
        }
        this.sendFinders(sites, encodedQuery, type);
        Collections.sort(results);
        return (ProductInfo[]) results.toArray(new ProductInfo[results.size()]); 
    }
    
    private void sendFinders(Vector sites, String query, boolean type)
    {
        Thread[] threads = new Thread[sites.size()];
        for (int i=0; i < sites.size(); i++)
            threads[i] = ((ProductFinder)sites.get(i)).search(query, type);
        for (int i=0; i < sites.size(); i++)
        {
            try
            {
                threads[i].join();
            }
            catch (InterruptedException x)
            { 
                System.out.println("Could not join thread");
            }
        }
    }
}
