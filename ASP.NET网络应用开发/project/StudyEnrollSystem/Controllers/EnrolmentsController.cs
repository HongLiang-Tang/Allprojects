using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using FIT5032_Week08A.Utils;
using Login04.Models;
using Microsoft.AspNet.Identity;

namespace Login04.Controllers
{
    public class EnrolmentsController : Controller
    {
        private Model1Container db = new Model1Container();

        // GET: Enrolments
        public ActionResult Index()
        {

            var UserId = User.Identity.GetUserId();
            
            if (User.IsInRole("admin")) 
            { 
                var enrolmentsA = db.Enrolments.Include(e => e.Course);
                return View(enrolmentsA.ToList());


            }
            var enrolments = db.Enrolments.Include(e => e.Course).Where(e=>e.UserId == UserId);
            return View(enrolments.ToList());


        }
        public ActionResult Calendar()
        {

            var UserId = User.Identity.GetUserId();

            if (User.IsInRole("admin"))
            {
                var enrolmentsA = db.Enrolments.Include(e => e.Course);
                return View(enrolmentsA.ToList());


            }
            var enrolments = db.Enrolments.Include(e => e.Course).Where(e => e.UserId == UserId);
            return View(enrolments.ToList());


        }



        public ActionResult Chart()
        {
            return View();
        }
        
        public ActionResult ShowChart(string startDate, string endDate)
        {
            System.DateTime sDate = System.DateTime.Parse(startDate);
            System.DateTime eDate = System.DateTime.Parse(endDate);
            var chartList = new List<Chart>();
            var cList = db.Courses.ToList();
            foreach (var c in cList) 
            {
                Chart chart = new Chart();
                chart.Name = c.CourseName;
                var a = db.Enrolments.Where(e => e.CourseId == c.Id).ToList();
                var count = 0;
                foreach (var e in a) 
                {
                    if (e.EnrolDate.CompareTo(sDate) >= 0 && e.EnrolDate.CompareTo(eDate) <= 0)
                        count += 1;
                }
                chart.Count = count;
                chartList.Add(chart);
            }


            return View(chartList);
        }


        // GET: Enrolments/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Enrolment enrolment = db.Enrolments.Find(id);
            if (enrolment == null)
            {
                return HttpNotFound();
            }
            return View(enrolment);
        }

        // GET: Enrolments/Create
        public ActionResult Create()
        {
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName");
            return View();
        }

        public ActionResult CalendarCreate(String date)
        {
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName");
            if (null == date)
                return RedirectToAction("Index");
            Enrolment e = new Enrolment();
            DateTime convertedDate = DateTime.Parse(date);
            e.EnrolDate = convertedDate;
            return View(e);
            
        }



        // POST: Enrolments/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize]
        public ActionResult Create([Bind(Include = "Id,EnrolDate,UserId,UserEmail,CourseId")] Enrolment enrolment)
        {
            //alternative way: remove UserId in Bind(Include=...) (this way we can hide the needs for user input but I still perfer to let user know UserId is entered automatically(usability design)
            //then enrolment.UserId = User.Identity.GetUserId(); to get the current login user
            //ModelState.Clear(); since we add the UserId here instead of using binding form, when we bind it will perform ModelState.Clear and TryValiadateModel these two steps and
            //the state is definitely invalid.
            //TryValidateModel(booking); validate the model again and it will be valid. So later ModelState.IsValid can be true as it is valid.
            //At last, in the view page, we need to comment out the UserId section.
            var userName = enrolment.UserEmail;
            var enrolDate = enrolment.EnrolDate.ToString();
            var courseId = enrolment.CourseId.ToString();
            EmailAsync(userName, enrolDate, courseId);
            bool flag = true;
           
            var enrol = db.Enrolments;
            foreach (var item in enrol)
            {
                if (item.UserId == enrolment.UserId && item.CourseId == enrolment.CourseId)
                    flag = false;
            }
            if (ModelState.IsValid && flag)
            {
                db.Enrolments.Add(enrolment);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.Warning = "It seems that you have already enrolled this Course, Please Don't enroll multiple times";
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", enrolment.CourseId);
            //return View(db.Enrolments.Where(m=>m.UserId==User.Identity.GetUserId();).ToList()); this will return the data table for specific userid but I want admin to see all data,
            //so it is simpler to perform in the view page. or do if statement here and return different data table.
            return View(enrolment);
        }


        // GET: Enrolments/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Enrolment enrolment = db.Enrolments.Find(id);
            if (enrolment == null)
            {
                return HttpNotFound();
            }
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", enrolment.CourseId);
            return View(enrolment);
        }

        // POST: Enrolments/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,EnrolDate,UserId,UserEmail,CourseId")] Enrolment enrolment)
        {
            if (ModelState.IsValid)
            {
                db.Entry(enrolment).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", enrolment.CourseId);
            return View(enrolment);
        }

        // GET: Enrolments/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Enrolment enrolment = db.Enrolments.Find(id);
            if (enrolment == null)
            {
                return HttpNotFound();
            }
            return View(enrolment);
        }

        // POST: Enrolments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Enrolment enrolment = db.Enrolments.Find(id);
            var courseRating = db.CourseRatings.Where(a => a.CourseId == enrolment.CourseId && a.UserId == enrolment.UserId);
            if (courseRating != null) {
                foreach (var c in courseRating) {
                    db.CourseRatings.Remove(c);
                }
            }
            db.Enrolments.Remove(enrolment);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public async System.Threading.Tasks.Task<ActionResult> EmailAsync(String Username, String EnrolDate, String CourseId) 
        {
            String toEmail = User.Identity.GetUserName();
            String body = "Dear (" + Username + ") Your enrolment on CourseId: " + CourseId + " at "+ EnrolDate + " Has been confirmed";
            EmailSender es = new EmailSender();
            await es.Send(toEmail,body);
            return null;
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize]
        public ActionResult CalendarCreate([Bind(Include = "Id,EnrolDate,UserId,UserEmail,CourseId")] Enrolment enrolment)
        {
            //alternative way: remove UserId in Bind(Include=...) (this way we can hide the needs for user input but I still perfer to let user know UserId is entered automatically(usability design)
            //then enrolment.UserId = User.Identity.GetUserId(); to get the current login user
            //ModelState.Clear(); since we add the UserId here instead of using binding form, when we bind it will perform ModelState.Clear and TryValiadateModel these two steps and
            //the state is definitely invalid.
            //TryValidateModel(booking); validate the model again and it will be valid. So later ModelState.IsValid can be true as it is valid.
            //At last, in the view page, we need to comment out the UserId section.
            var userName = enrolment.UserEmail;
            var enrolDate = enrolment.EnrolDate.ToString();
            var courseId = enrolment.CourseId.ToString();
            EmailAsync(userName, enrolDate, courseId);
            bool flag = true;

            var enrol = db.Enrolments;
            foreach (var item in enrol)
            {
                if (item.UserId == enrolment.UserId && item.CourseId == enrolment.CourseId)
                    flag = false;
            }
            if (ModelState.IsValid && flag)
            {
                db.Enrolments.Add(enrolment);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.Warning = "It seems that you have already enrolled this Course, Please Don't enroll multiple times";
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", enrolment.CourseId);
            //return View(db.Enrolments.Where(m=>m.UserId==User.Identity.GetUserId();).ToList()); this will return the data table for specific userid but I want admin to see all data,
            //so it is simpler to perform in the view page. or do if statement here and return different data table.
            return View(enrolment);
        }
    }
}
