
using FIT5032_Week08A.Utils;
using Login04.Models;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Login04.Controllers
{
    [RequireHttps]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult Send_Email()
        {
            return View(new SendEmailViewModel());
        }

        [HttpPost]
        public ActionResult Send_Email([Bind(Include = "ToEmail, Subject, Contents")] SendEmailViewModel model, HttpPostedFileBase postedFile)
        {
            ModelState.Clear();
            var myUniqueFileName = string.Format(@"{0}", Guid.NewGuid());
            model.Path = myUniqueFileName;
            TryValidateModel(model);
            
            if (ModelState.IsValid)
            {
                string serverPath = Server.MapPath("~/Uploads/");
                if (postedFile is null) 
                {
                    try
                    {
                        String toEmail = model.ToEmail;
                        String subject = model.Subject;
                        String contents = model.Contents;

                        EmailSender es = new EmailSender();
                        es.EnquiryNoAttachment(toEmail, subject, contents);

                        ViewBag.Result = "Email has been send.";

                        ModelState.Clear();

                        return View("~/Views/Home/Index.cshtml");
                    }
                    catch
                    {
                        return View();
                    }

                }
                string fileExtension = Path.GetExtension(postedFile.FileName);
                string filepath = model.Path + fileExtension;
                model.Path = filepath;
                postedFile.SaveAs(serverPath + model.Path);
                var routePath = serverPath + model.Path;
                var fileName = model.Path;
                try
                {
                    String toEmail = model.ToEmail;
                    String subject = model.Subject;
                    String contents = model.Contents;

                    EmailSender es = new EmailSender();
                    es.Enquiry(toEmail, subject, contents, routePath, fileName);

                    ViewBag.Result = "Email has been send.";

                    ModelState.Clear();

                    return View(new SendEmailViewModel());
                }
                catch
                {
                    return View();
                }
            }

            return View();
        }

    }


    


}