using api_project_for_flutter.Models;
using Dapper;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace api_project_for_flutter.OtherOperations
{
    public class MySqlDataAccess : IDataAccess
    {
        public string ConnectionString = @"";

        public bool IsUserValid(UserModel user)
        {
            using (IDbConnection cnn = new MySqlConnection(ConnectionString))
            {
                var p = new DynamicParameters();
                p.Add("@name", user.name);
                p.Add("@password", user.password);

                string sql = @"SELECT COUNT(*) FROM users WHERE name=@name and password=@password";

                var output = cnn.Query<int>(sql, p).ToList();
                if (output[0] != 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public List<NoteModel> GetUserNotes(UserModel user)
        {
            using (IDbConnection cnn = new MySqlConnection(ConnectionString))
            {
                int userId = GetUserId(user);
                var p = new DynamicParameters();
                p.Add("@userId", userId);

                string sql = @"SELECT * FROM notes WHERE userId=@userId";

                var output = cnn.Query<NoteModel>(sql, p).ToList();
                return output;
            }
        }

        public bool InsertUser(UserModel user)
        {
            using (IDbConnection cnn = new MySqlConnection(ConnectionString))
            {
                var p = new DynamicParameters();
                p.Add("@username", user.name);
                p.Add("@password", user.password);

                string sql = @"INSERT INTO users(name,password) VALUES(@username,@password);";
                cnn.Execute(sql, p);
                return true;
            }
        }

        public List<UserModel> GetAllUsers()
        {
            using (IDbConnection cnn = new MySqlConnection(ConnectionString))
            {
                string sql = @"SELECT * FROM users";

                var output = cnn.Query<UserModel>(sql).ToList();
                return output;
            }
        }

        public bool AddNote(NoteModel note)
        {
            using (IDbConnection cnn = new MySqlConnection(ConnectionString))
            {
                var p = new DynamicParameters();
                p.Add("@userId", note.userId);
                p.Add("@note", note.note);

                string sql = @"INSERT INTO notes(userId,note) VALUES(@userId,@note)";

                cnn.Execute(sql, p);

                return true;
            }
        }



        public bool DeleteNote(NoteModel note)
        {
            using (IDbConnection cnn = new MySqlConnection(ConnectionString))
            {
                var p = new DynamicParameters();
                p.Add("@userId", note.userId);
                p.Add("@Id", note.Id);

                string sql = @"DELETE FROM notes WHERE Id=@Id and userId=@userId";

                cnn.Execute(sql, p);

                return true;
            }
        }


        public int GetUserId(UserModel user)
        {
            using (IDbConnection cnn = new MySqlConnection(ConnectionString))
            {
                var p = new DynamicParameters();
                p.Add("@name", user.name);
                p.Add("@password", user.password);

                string sql = @"SELECT Id FROM users WHERE name=@name and password=@password";

                int output = cnn.Query<int>(sql, p).ToList().First();
                return output;
            }
        }

    }
}
