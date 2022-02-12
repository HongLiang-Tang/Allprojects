using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Login04.Models;
using Microsoft.Ajax.Utilities;

namespace Login04.Controllers
{
    public class CoursesController : Controller
    {
        private Model1Container db = new Model1Container();

        // GET: Courses
        public ActionResult Index()
        {
            var courses = db.Courses.Include(c => c.Service).Include(c => c.State);
            return View(courses.ToList());
        }

        public ActionResult Rating()
        {
            var courses = db.Courses.Include(c => c.Service).Include(c => c.State);
            var coursesc = db.Courses;
            var a = new List<Course>();
            
            foreach (var c in coursesc) 
            {
                var courseRatings = db.CourseRatings.Where(d => d.CourseId == c.Id).ToList();
                var totalRating = 0;
                foreach(var r in courseRatings)
                {
                    totalRating += int.Parse(r.Rate.Rating);
                }
                double averageRating = double.Parse(totalRating.ToString()) / double.Parse(courseRatings.Count.ToString());
                c.Rating = averageRating.ToString();
                a.Add(c);
            }
            return View(a);
        }

        // GET: Courses/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Course course = db.Courses.Find(id);
            if (course == null)
            {
                return HttpNotFound();
            }
            return View(course);
        }

        // GET: Courses/Create
        [Authorize(Roles = "admin")]
        public ActionResult Create()
        {
            ViewBag.ServiceId = new SelectList(db.Services, "Id", "ServiceName");
            ViewBag.StateId = new SelectList(db.States, "Id", "Status");
            return View();
        }

        // POST: Courses/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,CourseName,ContactEmailForCourse,ContactNumber,CourseDescription,StartDate,EndDate,ServiceId,StateId")] Course course)
        {
            
            ModelState.Clear();
            course.Rating = "0";
            TryValidateModel(course);
            if (ModelState.IsValid)
            {
                db.Courses.Add(course);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.ServiceId = new SelectList(db.Services, "Id", "ServiceName", course.ServiceId);
            ViewBag.StateId = new SelectList(db.States, "Id", "Status", course.StateId);
            return View(course);
        }

        // GET: Courses/Edit/5
        [Authorize(Roles = "admin")]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Course course = db.Courses.Find(id);
            if (course == null)
            {
                return HttpNotFound();
            }
            ViewBag.ServiceId = new SelectList(db.Services, "Id", "ServiceName", course.ServiceId);
            ViewBag.StateId = new SelectList(db.States, "Id", "Status", course.StateId);
            return View(course);
        }

        // POST: Courses/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,CourseName,ContactEmailForCourse,ContactNumber,CourseDescription,StartDate,EndDate,ServiceId,StateId")] Course course)
        {
            if (ModelState.IsValid)
            {
                db.Entry(course).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.ServiceId = new SelectList(db.Services, "Id", "ServiceName", course.ServiceId);
            ViewBag.StateId = new SelectList(db.States, "Id", "Status", course.StateId);
            return View(course);
        }

        // GET: Courses/Delete/5
        [Authorize(Roles = "admin")]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Course course = db.Courses.Find(id);
            if (course == null)
            {
                return HttpNotFound();
            }
            return View(course);
        }

        // POST: Courses/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Course course = db.Courses.Find(id);
            //delete cascade
            var courseRating = db.CourseRatings.Where(a => a.CourseId == id);
            if (courseRating != null)
            {
                foreach (var rating in courseRating)
                {
                    db.CourseRatings.Remove(rating);
                }
            }
            
            var enrolment = db.Enrolments.Where(a => a.CourseId == id);
            if (enrolment != null)
            {
                foreach (var enrol in enrolment)
                {
                    db.Enrolments.Remove(enrol);
                }
            }
            
            var studio = db.Studios.Where(a => a.CourseId == id);
            if (studio != null)
            {
                foreach (var stu in studio)
                {
                    db.Studios.Remove(stu);
                }

            }
            
            db.Courses.Remove(course);
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
