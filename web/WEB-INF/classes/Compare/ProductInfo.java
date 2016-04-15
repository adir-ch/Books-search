package Compare;

public class ProductInfo implements Comparable
{
    
    private String productSiteURL, productName, productLink, direction, productSiteImage;
    private double productPrice;
    
    public ProductInfo(String url, String sImage, String pName, double pPrice, String pLink, String pDir)
    {
        this.productSiteURL = url;
        this.productName = pName;
        this.productPrice = pPrice;
        this.productLink = pLink;
        this.direction = pDir;
        this.productSiteImage = sImage;
    }
    
    public int compareTo(Object o)
    {
        ProductInfo other = (ProductInfo) o;
        if (this.productPrice > other.productPrice)
            return 1;
        else 
            if (this.productPrice < other.productPrice)
                return -1;
            else 
                return this.productName.compareTo(other.productName);     
    }
    
    
    public String[] getProductAsHtmlTableCells() throws Exception 
    {
        String pName = new String (this.productName.getBytes("ISO8859_8"), "ISO8859_1");
        String name;
        if (!this.direction.equalsIgnoreCase("none"))
            name = "<BDO dir = '" + this.direction +"'>" + pName + "</BDO>";
        else
            name = pName;
        String siteLink = "<a href= '" + this.productSiteURL + "' target = '_blank'><img src=\"" + this.productSiteImage + "\" border=0 height=25></a>";
        String price;
        if (this.productPrice == 999999)
            price = "No price ";
        else
            price = " " + this.productPrice + " ";
        String celles[] = {name, siteLink, this.productLink, price};
        return celles;
    }
               
    
    public String toString()
    {
        return new String (this.productName + " " + this.productSiteURL + " " + this.productPrice + " " + this.productLink);
        //return new String (this.productName + " " + this.productPrice);
    }
}
