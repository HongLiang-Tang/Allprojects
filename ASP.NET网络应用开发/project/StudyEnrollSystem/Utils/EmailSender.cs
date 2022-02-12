using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace FIT5032_Week08A.Utils
{
    public class EmailSender
    {
        // Please use your API KEY here.
        private const String API_KEY = "APIkeyhiddenforSecurityPurpose";

        public async Task Send(String toEmail, String plainTextContent)
        {
            var client = new SendGridClient(API_KEY);
            var from = new EmailAddress("privateEmailHidden@gmail.com", "Email User");
            var to = new EmailAddress(toEmail, "");
            //var plainTextContent = "Your Enrolment has been confirmed";
            var subject = "Confirm";
            var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, "");
            var bytes = File.ReadAllBytes("D:\\study\\confirm.docx");
            //File.ReadAllBytes("D:\\study\\confirm.docx");
            var file = Convert.ToBase64String(bytes);
            msg.AddAttachment("confirm.docx", file);
            var response = await client.SendEmailAsync(msg);
        }

        public void Enquiry(String toEmail, String subject, String contents, String path, String fileName)
        {
            var client = new SendGridClient(API_KEY);
            var from = new EmailAddress("privateEmailHidden@gmail.com", "Email User");
            var to = new EmailAddress(toEmail, "");
            var plainTextContent = contents;
            var htmlContent = "<p>" + contents + "</p>";
            var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
            var bytes = File.ReadAllBytes(path);
            //File.ReadAllBytes("D:\\study\\confirm.docx");
            var file = Convert.ToBase64String(bytes);
            msg.AddAttachment(fileName, file);
            var response = client.SendEmailAsync(msg);
        }

        public void EnquiryNoAttachment(String toEmail, String subject, String contents)
        {
            var client = new SendGridClient(API_KEY);
            var from = new EmailAddress("privateEmailHidden@gmail.com", "Email User");
            var to = new EmailAddress(toEmail, "");
            var plainTextContent = contents;
            var htmlContent = "<p>" + contents + "</p>";
            var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
            
            //File.ReadAllBytes("D:\\study\\confirm.docx");
            
            
            var response = client.SendEmailAsync(msg);
        }


    }
}