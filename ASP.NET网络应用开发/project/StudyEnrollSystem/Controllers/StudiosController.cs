using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Login04.Models;

namespace Login04.Controllers
{
    public class StudiosController : Controller
    {
        private Model1Container db = new Model1Container();

        // GET: Studios
        public ActionResult Index()
        {
            var studios = db.Studios.Include(s => s.Course);
            return View(studios.ToList());
        }

        // GET: Studios/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Studio studio = db.Studios.Find(id);
            if (studio == null)
            {
                return HttpNotFound();
            }
            return View(studio);
        }

        // GET: Studios/Create
        [Authorize(Roles = "admin")]
        public ActionResult Create()
        {
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName");
            return View();
        }

        // POST: Studios/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,StudioName,Location,Latitude,Longitude,StartTime,FinishTime,StudioDescription,CourseId")] Studio studio)
        {
            if (ModelState.IsValid)
            {
                db.Studios.Add(studio);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", studio.CourseId);
            return View(studio);
        }

        // GET: Studios/Edit/5
        [Authorize(Roles = "admin")]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Studio studio = db.Studios.Find(id);
            if (studio == null)
            {
                return HttpNotFound();
            }
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", studio.CourseId);
            return View(studio);
        }

        // POST: Studios/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,StudioName,Location,Latitude,Longitude,StartTime,FinishTime,StudioDescription,CourseId")] Studio studio)
        {
            if (ModelState.IsValid)
            {
                db.Entry(studio).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.CourseId = new SelectList(db.Courses, "Id", "CourseName", studio.CourseId);
            return View(studio);
        }

        // GET: Studios/Delete/5
        [Authorize(Roles = "admin")]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Studio studio = db.Studios.Find(id);
            if (studio == null)
            {
                return HttpNotFound();
            }
            return View(studio);
        }

        // POST: Studios/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Studio studio = db.Studios.Find(id);
            db.Studios.Remove(studio);
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
