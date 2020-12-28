using api_project_for_flutter.Models;
using System.Collections.Generic;

namespace api_project_for_flutter.OtherOperations
{
    public interface IDataAccess
    {
        bool AddNote(NoteModel note);
        bool DeleteNote(NoteModel note);
        List<UserModel> GetAllUsers();
        int GetUserId(UserModel user);
        List<NoteModel> GetUserNotes(UserModel user);
        bool InsertUser(UserModel user);
        bool IsUserValid(UserModel user);
    }
}