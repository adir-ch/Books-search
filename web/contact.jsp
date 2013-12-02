<%@ page contentType="text/html; charset=windows-1255" %>
<HTML>
<HEAD>
<TITLE>
Contact
</TITLE>
</HEAD>
<BODY bgcolor = '#FFEBD8'>
<H1 ALIGN="center">
Contact Form
</H1>
<FORM ACTION="mailto:adir@matavtv.net?subject=Feedback" METHOD="POST" ENCTYPE="text/plain">
<TABLE CELLSPACING="0" CELLPADDING="5" WIDTH="300" ALIGN="CENTER" BORDER="0">
  <TR>
    <TD CLASS="bodytext">Name:</TD>
    <TD CLASS="bodytext"><INPUT TYPE="TEXT" NAME="Name" SIZE="20"></TD>
  </TR>
  <TR>
    <TD CLASS="bodytext">Email:</TD>
    <TD CLASS="bodytext"><INPUT TYPE="TEXT" NAME="Email" SIZE="20"></TD>
  </TR>
  <TR>
    <TD CLASS="bodytext">Age:</TD>
    <TD CLASS="bodytext">
      <SELECT NAME="Age">
        <OPTION VALUE="10 or under">10 or under</OPTION>
        <OPTION VALUE="11-20">11-20</OPTION>
        <OPTION VALUE="21-30" SELECTED>21-30</OPTION>
        <OPTION VALUE="31-40">31-40</OPTION>
        <OPTION VALUE="41-50">41-50</OPTION>
        <OPTION VALUE="Over 50">Over 50</OPTION>
      </SELECT>
    </TD>
  </TR>
  <TR VALIGN="TOP">
    <TD CLASS="bodytext">Sex:</TD>
    <TD CLASS="bodytext">
      <INPUT TYPE="RADIO" NAME="Sex" VALUE="Male" CHECKED> Male<BR>
      <INPUT TYPE="RADIO" NAME="Sex" VALUE="Female"> Female<BR>
    </TD>
  </TR>
  <TR VALIGN="TOP">
    <TD CLASS="bodytext">Occupation:</TD>
    <TD CLASS="bodytext">
      <SELECT NAME="Occupation">
        <OPTION VALUE="Soldier">Soldier</OPTION>
        <OPTION VALUE="Student" SELECTED>Student</OPTION>
        <OPTION VALUE="Teacher">Teacher</OPTION>
        <OPTION VALUE="Programmer">Programmer</OPTION>
        <OPTION VALUE="Freelancer">Freelancer</OPTION>
      </SELECT>
    </TD>
  </TR>
  <TR VALIGN="TOP">
    <TD CLASS="bodytext">Comments:</TD>
    <TD CLASS="bodytext">
      <TEXTAREA ROWS="5" COLS="30" NAME="Comments"></TEXTAREA>
    </TD>
  </TR>
  <TR>
    <TD CLASS="bodytext">&nbsp;</TD>
    <TD ALIGN="CENTER" CLASS="bodytext">
      <INPUT TYPE="RESET" VALUE="Reset">
      <INPUT TYPE="SUBMIT" VALUE="Submit">
    </TD>
  </TR>
</TABLE>
</FORM>
<A HREF="http://mars.netanya.ac.il/~coheadir/index.html">Back...</A>
</BODY>
</HTML>