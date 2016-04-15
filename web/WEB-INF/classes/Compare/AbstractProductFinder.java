package Compare;

import java.util.*;
import java.io.*;

public abstract class AbstractProductFinder implements ProductFinder
{
    protected String searchQuery;
    protected String searchRequest;
    protected ConfigurationFile searchProperties;
    protected boolean searchType;
    private ArrayList results;
    
    public AbstractProductFinder(ArrayList results, ConfigurationFile searchProp) 
    {
        this.results = results;
        this.searchProperties = searchProp;
    }
    
    protected abstract InputStream getResponseStream () throws IOException; 
   
     public String getFinderName()
    {
        return (String)this.searchProperties.get("name");
    }
     
    public Thread search (String query, boolean type)
    {
        this.searchQuery = query;
        this.searchType = type;
        Thread thread = new Thread (this); 
        thread.start();
        return thread;
    }
    
    public void run() 
    {
        try 
        {
            InputStream in = this.getResponseStream();
            if (in != null)
            {
                BufferedReader reader = new BufferedReader (new InputStreamReader (in,"ISO8859_8"));
                StringBuffer siteResponse = new StringBuffer();
                String line;
                while ((line = reader.readLine()) != null)
                    siteResponse.append(line);
                this.analizeWebPage(siteResponse.toString());
            }
            else
                System.out.println("Web site is unavailable");
        }
        catch (IOException e)
        {
            //System.out.println(e.toString());
            System.out.println("An Error found in: " + this.getFinderName());
        }
    }
    
    private void analizeWebPage(String sr)
    {
        System.out.println("Starting to pars: " + this.searchProperties.get("site-url"));
        String nameSeperator = "*_*";
        String priceSeperator = "_*_";
        if (sr.indexOf((String)this.searchProperties.get("product-not-found")) == -1)
        {
            sr = sr.replaceAll(this.searchProperties.get("results-start-regexp") + "|" + this.searchProperties.get("results-end-regexp"), nameSeperator);
            int startIndex = sr.indexOf(nameSeperator);
            int endIndex = sr.indexOf(nameSeperator, startIndex + nameSeperator.length());
            sr = sr.substring(startIndex + nameSeperator.length(),endIndex);
            sr = sr.replaceAll("\t{2,}", ""); 
            sr = sr.replaceAll((String)this.searchProperties.get("product-name-start-regexp"), nameSeperator);
            sr = sr.replaceAll((String)this.searchProperties.get("product-name-end-regexp"), nameSeperator);
            sr = sr.replaceAll((String)this.searchProperties.get("product-price-start-regexp"), priceSeperator);
            sr = sr.replaceAll((String)this.searchProperties.get("product-price-end-regexp"), priceSeperator);
            this.getProducts(sr, nameSeperator, priceSeperator, nameSeperator.length());          
        }
        else
            System.out.println("products not found in: " + this.searchProperties.get("site-url"));
    }
    
    private void getProducts(String sr, String seperator, String pSeperator, int len)
    {
        int nameStartIndex, nameEndIndex, priceStartIndex, priceEndIndex, nextproductIndex;
        nameStartIndex = nameEndIndex = priceStartIndex = priceEndIndex = nextproductIndex = 0;
        String productName, pLink;
        double productPrice;
        String siteName = (String)this.searchProperties.get("site-url");
        String direction = (String)this.searchProperties.get("hebrew-dir");
        nameStartIndex = sr.indexOf(seperator);
        while (nameStartIndex > -1)
        {
            nameEndIndex = sr.indexOf(seperator, nameStartIndex + 1);
            productName = sr.substring(nameStartIndex + len , nameEndIndex);
            priceStartIndex = sr.indexOf(pSeperator,nameStartIndex);
            nextproductIndex = sr.indexOf(seperator,nameEndIndex + 1);
            if (((priceStartIndex < nextproductIndex) && (priceStartIndex > -1)) || ((priceStartIndex > -1) && (nextproductIndex == -1)))
            {
                String price = sr.substring(priceStartIndex + len , (priceEndIndex = sr.indexOf(pSeperator,priceStartIndex + 1)));
                price = price.replaceAll("[^0-9.]", "");
                productPrice = Double.parseDouble(price);
            }
            else 
                productPrice = this.getAlterPrice(sr, nameStartIndex);
            pLink = this.getProductLink(sr, nameStartIndex, nextproductIndex);
            
            this.results.add(new ProductInfo(siteName, (String)this.searchProperties.get("image"), productName, productPrice, pLink, direction));
            nameStartIndex = nextproductIndex;
        }    
    }
    
    private double getAlterPrice(String sr, int ind)
    {
        String search = (String)this.searchProperties.get("product-alter-price-start");
        if (search.length() == 0)
            return 999999;
        else
        {
            int st,se;
            st = sr.indexOf(search, ind);
            if (st > -1)
            {
                se = sr.indexOf((String)this.searchProperties.get("product-alter-price-end"), st +1);
                sr = sr.substring(st + search.length(), se);
                sr = sr.replaceAll("[^0-9.]", "");
                return Double.parseDouble(sr);
            }
            else 
            {
                if ((search = (String)this.searchProperties.get("one-page-price-start")) != null)
                {
                    st = sr.indexOf(search, ind);
                    if (st > -1)
                    {
                        se = sr.indexOf((String)this.searchProperties.get("one-page-price-end"), st +1);
                        sr = sr.substring(st + search.length(), se);
                        sr = sr.replaceAll("[^0-9.]", "");
                        return Double.parseDouble(sr);
                    }
                }
                return 999999;
            }
        }
    }
    
    private String getProductLink (String sr, int startInd, int endInd)
    {
        String linkAdress = (String)this.searchProperties.get("product-link-start");
        if (endInd > -1) 
            sr = sr.substring(startInd, endInd);
        else 
            sr = sr.substring(startInd);
        int st = sr.indexOf(linkAdress);
        if (st > -1)
        {
            int se = sr.indexOf((String)this.searchProperties.get("product-link-end"), st);
            return (this.searchProperties.get("product-link") + sr.substring(st + linkAdress.length(),se));
        }
        return "no link";
    }
            
}
 
