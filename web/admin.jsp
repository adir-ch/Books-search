<%@page contentType="text/html"%>
<%@ page import= "java.io.*" %>
<%@ page import= "java.util.*" %>
<%@ page import= "java.net.*" %>
<%@ page import= "Member.*" %>

<jsp:useBean id="mailsender" scope="session" class="Member.mailSender" />

<%
String pass = "siteAdmin";
boolean auth = false;
String mode = request.getParameter("mode"); 

if (mode != null && mode.equals("Logout"))
    mode = null;

if (mode != null && mode.equals("Login") )
{
    String temp = request.getParameter("password");
    if (temp != null && !temp.equals(""))
        if (temp.equals(pass)) 
            auth = true;  
}

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

%>

<html>
<head><title>Administration Page</title></head>
<body bgcolor = '#FFFDCD'>
<h2><font color = 'blue'>Site Administration & Managment page</font></h2>
<% if (mode != null && (auth == true || mode.equals("Show members") ||  mode.equals("Email members") || mode.equals("Send email"))) { %> 
    <hr>
    You have been successfuly loged in !!! <br>
    Options: <br>
    <form method='post'>
        <INPUT type= SUBMIT name = "mode" value='Show members'>&nbsp;&nbsp;
        <INPUT type= SUBMIT name = "mode" value='Email members'>&nbsp;&nbsp;
        <INPUT type= SUBMIT name = "mode" value='Logout'>
    </form>
<% } %>

<hr>

<%  if (mode == null || (mode.equals("Login") && auth == false)) { %>
    <form method='post'>
        Please login: <input type = 'text' name = 'password' value=''><br><br>
        <INPUT type= SUBMIT name = "mode" value='Login'>
    </FORM>
<% } %>

<%  if (mode != null && mode.equals("Show members")) { %>
        <table cellspacing='3' cellpadding='3' bgcolor = '#6633CC' border='1'>
        <tr bgcolor='#FFCC66'><td>Site members</td></tr>
        <tr bgcolor='yellow'>
                <td>Number</td>
                <td>User name</td> 
                <td>Password</td> 
                <td>First name</td>
                <td>Last name</td>
                <td>Email Address</td>
                <td>Phone number</td>
        </tr>
        <% for (int i = 0; i < membersList.size(); i++) {  %>
            <tr bgcolor='#FFCC66'>
                <td align= 'center'><%= i+1 %></td>
                <td><%= ((member)(membersList.elementAt(i))).getId() %></td>
                <td><%= ((member)(membersList.elementAt(i))).getPass() %></td>
                <td><%= ((member)(membersList.elementAt(i))).getFirst() %></td>
                <td><%= ((member)(membersList.elementAt(i))).getLast() %></td>
                <td><%= ((member)(membersList.elementAt(i))).getEmail() %></td>
                <td><%= ((member)(membersList.elementAt(i))).getPhone() %></td>
            </tr>
        <% } %>
        </table>
   <% } %>

<%  if (mode != null && mode.equals("Email members")) { %>
<b><u><h4><font color = 'blue'>Use this form to send emailes to the site subscribers</font></h4></u><b>
    <form method='post'>
        <table bgcolor = '#6633CC'>
            <tr>
                <td><font color = 'white'>Use mail server </FONT></td>
                <td><input type = 'text' name = 'mail_host' value='<%= System.getProperty("mail.host") == null ? "" : System.getProperty("mail.host") %>'></td>
            </td>
            <tr>
                <td><font color = 'white'>Message subject </FONT></td>
                <td><input type = 'text' name = 'mail_subject' value=''></td>
            </td>
            <tr>
                <td><font color = 'white'>Message body </FONT></td>
                <td><TEXTAREA cols='50' rows='10' title='Message' name='messageBody'></TEXTAREA></td>
            </td>
        </table>
        <br><br>
        <INPUT type = 'submit' name = 'mode' value = 'Send email'><br><br>
        <input type = 'reset' name='reset' value='Reset'><br><br>
    </FORM>    
<% } %>

<%  if (mode != null && mode.equals("Send email")) { 
    String messageSubject = request.getParameter("mail_subject");
    String messageBody = request.getParameter("messageBody");
    mailsender.init("Adir site", "messageSubject", "messageBody");
    if (request.getParameter("mail_host") != null && !request.getParameter("mail_host").equals(""))
        mailsender.setMailHost(request.getParameter("mail_host"));
    for (int i = 0 ; i < membersList.size(); i++)
        if (((member)(membersList.elementAt(i))).wantsMail()) 
            mailsender.sendMail(((member)(membersList.elementAt(i))).getEmail());
    System.out.println("Mail sent using: " + request.getParameter("mail_host"));
} %>

</body>
</html>


















