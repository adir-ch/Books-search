package Compare;

public interface ProductFinder extends Runnable
{
    Thread search(String query, boolean type);
    String getFinderName();
}
