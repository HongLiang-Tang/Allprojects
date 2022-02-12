using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Login04.Models;
using Microsoft.AspNet.Identity;

namespace Login04.Controllers
{
    public class CourseRatingsController : Controller
    {
        private Model1Container db = new Model1Container();

        // GET: CourseRatings
        public ActionResult Index()
        {
            var courseRatings = db.CourseRatings.Include(c => c.Rate).Include(c => c.Course);
            return View(courseRatings.ToList());
        }

        

        // GET: CourseRatings/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CourseRating courseRating = db.CourseRatings.Find(id);
            if (courseRating == null)
            {
                return HttpNotFound();
            }
            return View(courseRating);
        }

        // GET: CourseRatings/Create
        public ActionResult Create()
        {
           
            ViewBag.RateId = new SelectList(db.Rates, "Id", "Rating");
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName");
            //var RelevantData = db.Enrolments;
            //foreach (var item in RelevantData) 
            
            return View();
        }

        // POST: CourseRatings/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,UserId,Comment,RateId,CourseId")] CourseRating courseRating)
        {
            bool flag = false;
            var userid = User.Identity.GetUserId();
            var enrol = db.Enrolments;
            bool indicator = true;
            var allrating = db.CourseRatings;
            //you cannot give rating to a course multiple times, you can only edit the existing rated score
            foreach (var item in allrating)
            {
                if (item.CourseId == courseRating.CourseId && item.UserId == courseRating.UserId)
                    indicator = false;
            }
            //you can only give rating to the course after you enroll this course
            foreach (var item in enrol) 
            {
                if (item.CourseId == courseRating.CourseId && item.UserId == userid)
                    flag = true;
            }
            //all requirement checked
            if (ModelState.IsValid && flag && indicator)
            {
                
                db.CourseRatings.Add(courseRating);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            //warning message if requirements didn't achieve
            if (!flag)
                ViewBag.Warning = "It seems that you haven't enrolled in the course you selected, please enroll in your selected course first";
            if (!indicator)
                ViewBag.Warning = "It seems that you have already rated this Course, you can only edit your rating instead of creating a new one";


            ViewBag.RateId = new SelectList(db.Rates, "Id", "Rating", courseRating.RateId);
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", courseRating.CourseId);
           
            return View(courseRating);
        }

        // GET: CourseRatings/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CourseRating courseRating = db.CourseRatings.Find(id);
            if (courseRating == null)
            {
                return HttpNotFound();
            }
            ViewBag.RateId = new SelectList(db.Rates, "Id", "Rating", courseRating.RateId);
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", courseRating.CourseId);
            return View(courseRating);
        }

        // POST: CourseRatings/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,UserId,Comment,RateId,CourseId")] CourseRating courseRating)
        {
            if (ModelState.IsValid)
            {
                db.Entry(courseRating).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.RateId = new SelectList(db.Rates, "Id", "Rating", courseRating.RateId);
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", courseRating.CourseId);
            return View(courseRating);
        }

        // GET: CourseRatings/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CourseRating courseRating = db.CourseRatings.Find(id);
            if (courseRating == null)
            {
                return HttpNotFound();
            }
            return View(courseRating);
        }

        // POST: CourseRatings/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            CourseRating courseRating = db.CourseRatings.Find(id);
            db.CourseRatings.Remove(courseRating);
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
    }
}
