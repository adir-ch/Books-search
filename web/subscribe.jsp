<%@ page contentType="text/html"%>
<%@ page import= "java.io.*" %>
<%@ page import= "java.util.*" %>
<%@ page import= "java.net.*" %>
<%@ page import= "Member.*" %>

<%
File membersFile = new File ("members.lst");
Vector membersList = null;
if (membersFile.exists())
{
    try {
        ObjectInputStream in = new ObjectInputStream (new FileInputStream(membersFile));
        membersList = (Vector) in.readObject();
        in.close();
    }
    catch (Exception exc) {
        System.out.println(exc.toString());
    }
}

if (membersList == null)
    membersList = new Vector();

response.setHeader("Cache-Control", "no-cache");
response.setHeader("Pragma", "no-cache");

String id		= request.getParameter("id");
String pass		= request.getParameter("pass");
String first	= request.getParameter("first");
String last		= request.getParameter("last");
String email	= request.getParameter("email");
String phone	= request.getParameter("phone");
String loadId	= request.getParameter("loadId");
String loadPass = request.getParameter("loadPass");
String mode		= request.getParameter("mode");

boolean formType = false;
boolean found = false;


boolean mailRec; 
String temp[] = request.getParameterValues("updates");
if (temp == null)
	mailRec = false;
else 
	mailRec = true;
	

if (mode != null && mode.equals("Reset"))
{
	id		 = null;
	pass	 = null;
	first	 = null;
	last	 = null;
	email	 = null;
	phone	 = null;
	mailRec  = false;
	loadId	 = null;
	loadPass = null;
}
else if (mode == null) 
		mode = new String("");
else if (mode.equals("Register"))
		formType = true; 


if (mode.equals("Login") && loadId != null && !loadId.equals("") && loadPass != null && !loadPass.equals("") )
{
	System.out.println("Login detected");
    for(int index = 0; index < membersList.size(); index++) 
    {
        if (((member)(membersList.elementAt(index))).compare(loadId, loadPass))
        {
            id = loadId;
            pass = loadPass;
            first = ((member)(membersList.elementAt(index))).getFirst();
            last = ((member)(membersList.elementAt(index))).getLast();
            phone = ((member)(membersList.elementAt(index))).getPhone();
            email = ((member)(membersList.elementAt(index))).getEmail();
			mailRec = ((member)(membersList.elementAt(index))).wantsMail();
            Cookie cookie = new Cookie("ktgw", id + "#" + first + "#" + last);
            cookie.setMaxAge(15 * 365 * 24 * 60 * 60);
            response.addCookie(cookie);
			found = true;
			formType = true;
            break;
        } 
    } 
    if (!found) { %>
        <h3><font color = 'red'>Member was not found</FONT></H3>
<% }
}

else if (mode.equals("Create"))
{
	System.out.println("Create detected");
	if (loadId != null && !loadId.equals(""))
    {
		for(int index = 0; index < membersList.size(); index++) 
		{
			if (((member)(membersList.elementAt(index))).compare(loadId))
			{
				found = true;
				break;
			}
		}
		if (found) { %>
			<h3><font color = 'red'>Sorry: User name already taken choose another one</FONT></H3>	
		<%  }
		else {
			formType = true; 
			id = loadId; %>
			<h3><font color = 'blue'>Create a new user:</FONT></H3>
		<% }
	}
}
	
else if (mode.equals("Register new user")) 
{ 
	formType = true;
    if (id != null && !id.equals(""))
    {
		if (pass != null && !pass.equals("")) 
		{			
			for(int index = 0; index < membersList.size(); index++) {
				if (((member)(membersList.elementAt(index))).compare(id))
				{
					found = true;
					break;
				}
			}
			if (found) { %>
				<h3><font color = 'red'>Sorry: user name already taken please choose another one</FONT></H3>	
			<%  }
			else 
			{
				Cookie cookie = new Cookie("ktgw", id + "#" + first + "#" + last);
				cookie.setMaxAge(15 * 365 * 24 * 60 * 60);
				response.addCookie(cookie);
				membersList.addElement(new member(id, pass, first, last, phone, email, mailRec));
				ObjectOutputStream outF = new ObjectOutputStream (new FileOutputStream(membersFile));
				outF.writeObject(membersList);
				outF.close(); %>
				<h3><font color = 'blue'>Thank you for your registration</FONT></H3>
			<% }
		}
		else { %>
			<h3><font color = 'red'>To register or update detailes please insert password</FONT></H3>
		<% } 
    }
}
else if (mode.equals("Update user"))
{
	formType = true;
    if (id != null && !id.equals(""))
    {
		if (pass != null && !pass.equals("")) 
		{			
			for(int index = 0; index < membersList.size(); index++) {
				if (((member)(membersList.elementAt(index))).compare(id))
				{
					found = true;
					break;
				}
			}
			if (!found) { %>
				<h3><font color = 'red'>Sorry: user name was not found, update aborted</FONT></H3>	
			<%  }
			else 
			{
				Cookie cookie = new Cookie("ktgw", id + "#" + first + "#" + last);
				cookie.setMaxAge(15 * 365 * 24 * 60 * 60);
				response.addCookie(cookie);
				for (int i = 0; i < membersList.size(); i++)
					if (((member)(membersList.elementAt(i))).compare(id))
						membersList.removeElementAt(i);
				membersList.addElement(new member(id, pass, first, last, phone, email, mailRec));
				ObjectOutputStream outF = new ObjectOutputStream (new FileOutputStream(membersFile));
				outF.writeObject(membersList);
				outF.close(); %>
				<h3><font color = 'blue'>Detailes Updated successfully</FONT></H3>
			<% }
		}
		else { %>
			<h3><font color = 'red'>To update detailes you mast supply password</FONT></H3>
		<% } 
    }
}

else if (mode.equals(""))
{
    System.out.println("Entry detected");
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for(int i = 0; i < cookies.length; i++)
	{
           if (cookies[i].getName().equalsIgnoreCase("ktgw")) 
           {
               String[] info = cookies[i].getValue().split("#");
               id = info[0];
               first = info[1];
               last = info[2];
	       for(int ind = 0; ind < membersList.size(); ind++)
	       {
                    if (((member)(membersList.elementAt(ind))).compare(id))
                    {
                        phone = ((member)(membersList.elementAt(ind))).getPhone();
                        email = ((member)(membersList.elementAt(ind))).getEmail();
						mailRec = ((member)(membersList.elementAt(ind))).wantsMail();
						formType = true;
						found = true;
						break;
                    }
               }
           }
        }
    }
} 

else if (mode.equals("Remove user"))
{
    System.out.println("Remove detected");
    for (int i = 0; i < membersList.size(); i++)
        if (((member)(membersList.elementAt(i))).compare(id, pass))
        {
            membersList.removeElementAt(i);
            ObjectOutputStream outF = new ObjectOutputStream (new FileOutputStream(membersFile));
	    outF.writeObject(membersList);
	    outF.close();
            break;
        }
} %>


<%-- WEB PAGE --%>
<html>
    <head>
        <title>Rgister Page</title>
    </head>
<body  bgcolor = '#FFEBD8'>
Hello: <%= ((id != null && found == true) ? id : request.getRemoteAddr()) %>
<hr>
<P><H3>Registration form:</H3>

<% if (formType == false) { %> 
		<br><H4>You can login by entering user name + password or create a new user name</H4>
<% } 
   else { %>
                <li> If you are registering a new user use the "Register new user button" only.
                <li> To Update details use "Update user" button only.
                <li> Reset will exit this page and returns to the enterence page.
                <li> Please remember to allow cookies in you browzer for more advanced use. <br>
		<br><H4><u>Your details</u>:</H4>
   <% } %>

<FORM method = post>
	<% if (formType == false) { %>	
		<table border='1' bgcolor='#3399FF'>
			<tr>
				<td>User name</td>
				<td><INPUT type= 'text' name = 'loadId' value=''></td>      
			</tr>
			<tr>
				<td>Password</td>
				<td><INPUT type= 'text' name = 'loadPass' value=''></td>      
			</tr>
		</table><BR><BR><BR>
	<% } 
	else { %> 	
               <table border='1' bgcolor='#FFCC99'>
			<tr>
				<td>User name</td>
				<td><INPUT type= 'text' name = 'id' value='<%= (id == null ? "" : id) %>'></td>      
			</tr>
			<tr>
				<td>Password</td>
				<td><INPUT type= 'text' name = 'pass' value='<%= (pass == null ? "" : pass) %>'></td>      
			</tr>
			<tr>
				<td>First Name</td>
				<td><INPUT type= 'text' name = 'first' value='<%= (first == null ? "" : first) %>'></td>      
			</tr>
			<tr>
				<td>Last Name</td>
				<td><INPUT type= 'text' name = 'last' value='<%= (last == null ? "" : last) %>'>   </td>      
			</tr>
			<tr>
				<td>Email Address</td>
				<td><INPUT type= 'text' name = 'email' value='<%= (email == null ? "" : email) %>'>   </td>      
			</tr>
			<tr>
				<td>Phone</td>
				<td><INPUT type= 'text' name = 'phone' value='<%= (phone == null ? "" : phone) %>'>   </td>      
			</tr>
			<tr bgcolor = 'yellow'>
				<td><INPUT type= 'checkbox' name = 'updates' value = 'sendMail' <%= (mailRec == true ? "checked" : "") %>></td>      
				<td> Add to mail list</td>
			</tr> 
		</table>   
	<% } %>

<% if (formType == false) { %> 
		<br><INPUT type= SUBMIT name = "mode" value='Login'><BR>
		<br><INPUT type= SUBMIT name = "mode" value='Create'>
<% }
   else { %> 
		<br><INPUT type= SUBMIT name = "mode" value='Register new user'><BR>
		<br><INPUT type= SUBMIT name = "mode" value='Remove user'> <br>
                <br><INPUT type= SUBMIT name = "mode" value='Update user'>
                   
   <% } %> 

</FORM>

<form method = 'post'>
	<input type= "submit" name = "mode" value = "Reset"></div>
</form>


</body>

</html>
