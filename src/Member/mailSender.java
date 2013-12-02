package Member;

import java.io.*;
import java.net.*;

public class mailSender {
    
    
    private String from;
    private String subject;
    private String body;
        
    public mailSender() {
    }
    
    public void init(String from, String subj, String bd)
    {
        this.from = from;
        this.subject = subj;
        this.body = bd;
    }
    
    public void setMailHost(String host)
    {
        System.getProperties().put("mail.host", host);
    }
    
    public void sendMail(String emailAddress)
    {
        try {
            URL url = new URL ("mailto:" + emailAddress);
            URLConnection con = url.openConnection();
            con.setDoInput(false);
            con.setDoOutput(true);
            con.connect();
            PrintWriter out = new PrintWriter (con.getOutputStream());
            out.println("From: " + this.from);
            out.println("To: " + emailAddress);
            out.println();
            out.println(this.body);
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }  
}
