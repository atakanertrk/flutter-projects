using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using api_project_for_flutter.OtherOperations;
using api_project_for_flutter.Models;
using System.Runtime.InteropServices.ComTypes;

namespace api_project_for_flutter.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class NotebookController : ControllerBase
    {
        IDataAccess dataAccess;
        public NotebookController()
        {
            dataAccess = new MySqlDataAccess();
        }

        public string Welcome()
        {
            return $"welcome to notebook api";
        }
        [HttpPost]
        public IActionResult IsUserValid([FromBody] UserModel user)
        {
            if (dataAccess.IsUserValid(user))
            {
                return Ok(); // 200
            }
            else
            {
                return NotFound(); // 404
            }
        }
        [HttpPost]
        public IActionResult GetUserNotes([FromBody] UserModel user)
        {
            if (dataAccess.IsUserValid(user))
            {
                return Ok(dataAccess.GetUserNotes(user)); // 200
            }
            else {
                return BadRequest(); // 400
            }
        }
        public class AddNoteModel
        {
            public string note { get; set; }
            public string name { get; set; }
            public string password { get; set; }
        }

        [HttpPost]
        public IActionResult AddNote([FromBody] AddNoteModel usernoteInput)
        {
            var userModel = new UserModel() { name = usernoteInput.name, password = usernoteInput.password };
            userModel.Id = dataAccess.GetUserId(userModel);
            var noteModel = new NoteModel() { note = usernoteInput.note, userId = userModel.Id };
            if (dataAccess.AddNote(noteModel))
            {
                return Ok(); // 200
            }
            else
            {
                return NotFound(); // 400
            }
        }

        public class DeleteNoteModel
        {
            public string name { get; set; }
            public string password { get; set; }
            public int noteId { get; set; }
        }

        [HttpPost]
        public IActionResult DeleteNote([FromBody] DeleteNoteModel request)
        {
            var userModel = new UserModel() { name = request.name, password = request.password };
            userModel.Id = dataAccess.GetUserId(userModel);
            var noteModel = new NoteModel() { Id = request.noteId, userId = userModel.Id };
            if (dataAccess.DeleteNote(noteModel))
            {
                return Ok(); // 200
            }
            else
            {
                return NotFound(); // 400
            }
        }

        [HttpGet]
        public IActionResult GetAllUserInfo()
        {
            var users = dataAccess.GetAllUsers();
            return Ok(users);
        }

        [HttpPost]
        public IActionResult InsertUser([FromBody] UserModel user)
        {
            if (dataAccess.InsertUser(user))
            {
                return Ok();
            }
            return StatusCode(400);
        }

    }
}
