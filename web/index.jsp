<%@ page contentType= "text/html" %>
<%@ page import= "Compare.*" %>
<%@ page import= "java.io.*" %>
<%@ page import= "java.util.*" %>
<%@ page import= "java.net.*" %>

<jsp:useBean id="sm" scope="request" class="Compare.SearchManager" />

<%
/*/ proxy settings 
System.getProperties().put("proxyset", "true");
System.getProperties().put("proxyHost", "192.168.2.254");
System.getProperties().put("proxyPort", "8080");
*/

String[] sites = sm.getSupportedSites();
for (int i=0; i < 4 ; i++)
	System.out.println(sites[i]);
String[] selectedSites = request.getParameterValues("sites");
String mode = request.getParameter("mode");
String myQuery = request.getParameter("query");
Hashtable searchOptions = new Hashtable();

if (mode != null)
{
    if(mode.equalsIgnoreCase("Reset"))
        for (int i = 0; i < sites.length; i++)
            searchOptions.put(sites[i], "true");
    else if (mode.equalsIgnoreCase("Search"))
    {
        for (int i = 0; i < sites.length; i++)
            searchOptions.put(sites[i], "false");
        for (int i = 0; (selectedSites != null) && (i < selectedSites.length) ; i++)
            searchOptions.put(selectedSites[i], "true");    
    }
}
else 
{
    for (int i = 0; i < sites.length; i++)
        searchOptions.put(sites[i], "true");
}
%>


<html>
<head>
<title>Books Compare</title>
<meta HTTP-EQUIV='Content-Type' content='text/html; charset=windows-1255'>
</head>

<body bgcolor = '#a5c3f3'>
<div align=right><font color = '#6666CC'><H3><b>Adir's books search page</b></H3></font></div>
<HR>
<FONT SIZE="" COLOR="#FF0000"><I>Hello:<%= request.getRemoteAddr()%></I></FONT>
<form method = 'post'>
<div align=right><input type= "submit" name = "mode" value = "Reset"></div>
</form>
<form enctype='text/html; Cp1255' method="post" bgcolor = '#FFCC33'>
<table bgcolor = '#0099FF' cellspacing='3' cellpadding='5' border = '0' width = "100%">
<tr>
<td>
        <input type = 'text' name='query' value="<%= (myQuery == null) ? "" : myQuery %>" style="HEIGHT: 22px">&nbsp&nbsp
        <select id="search_by" name="search_by" style="HEIGHT: 22px">
            <option value="item_name" selected>Book name</option>
            <option value="writer_name">Aouther name</option>
        </select>
        &nbsp&nbsp<input type= "submit" name = "mode" value = "Search" style="HEIGHT: 22px">
</td>
<td><FONT COLOR="#FF0000"><b>Search options:</b></FONT></td>
<% 
    Enumeration en = searchOptions.keys();
    while (en.hasMoreElements())
    {
        String site = (String) en.nextElement();
%>
                <td>
        <input type = "checkbox" name = "sites" value = "<%= site %>" 
            <%= (((String)searchOptions.get(site)).equalsIgnoreCase("true")) ? "checked" : "" %> > <%= site %>
                </td>
<% 
    } 
%>
</tr>
</table>
</form>
<hr>
<%
if ((selectedSites != null) && (myQuery != null) && ! (myQuery.equals("")))
{
    for (int i = 0; i < sites.length; i++)
        searchOptions.put(sites[i], "false");
    selectedSites = request.getParameterValues("sites");
    if (selectedSites != null)
        for (int i = 0; i < selectedSites.length; i++)
            searchOptions.put(selectedSites[i], "true");
    ProductInfo[] results = null;
    if (request.getParameter("search_by").equalsIgnoreCase("item_name"))
        results = sm.search(new String(myQuery.getBytes("ISO8859_1"), "ISO8859_8"), searchOptions, true); 
    else 
        results = sm.search(new String(myQuery.getBytes("ISO8859_1"), "ISO8859_8"), searchOptions, false); 
    if (results.length > 0)
    {
%>      
        <b><font color = '#3300FF'>Finished searching "<font color = 'yellow'><%= myQuery %></font>"</b><br>
        <b>Sites searched:
        <% for (int i=0; i < selectedSites.length; i++) { %>
            <font color ='yellow'><%= selectedSites[i] %></font>
        <% } %></b><br>
        <b>Found <b><font color = 'yellow'><%= results.length %></font></b> results</b><br>
        <p><table cellspacing='3' cellpadding='5' border='0' width = "100%">
                <tr bgcolor = '#0099FF'>
                        <td>&nbsp;</td>
                        <td><B>Book name</B></td>
                        <td align = 'center'><B>Store link</B></td>
                        <td align = 'center'><B>Detailes</B></td>
                        <td align = 'center'><B>Price</B></td>
                </tr>
<%
        for (int i = 0; i < results.length; i++) 
        {
            String celles [] = results[i].getProductAsHtmlTableCells();
%>  
            <tr bgcolor = '#99FFFF'>
                <td align = 'center'><%= i + 1 %></td> 
                <td align = 'left'><b><%= celles[0] %></b></td>
                <td align = 'center'><b><%= celles[1] %></b></td>
                <% if (((String)celles[2]).equalsIgnoreCase("no link")) { %>
                    <td align = 'center'><b>No link</b></td>
                <% } else { %>
                    <td align = 'center'><b><a href = '<%= celles[2] %>' target = '_blank'><img src=pictures/owl.gif alt="Product detailes" border=0 width=25 height=30></td></a>
                <% }%>
                <td bgcolor = 'yellow' align = 'center'><%= celles[3] %></td>      
            </tr>
<%
        }
%>
        </table>
<%
    } else {
%> 
        <b>Products not found</b>
<%
    }
}
%>

</body>
</html>