using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace api_project_for_flutter.Models
{
    public class UserModel
    {
        public int Id { get; set; }
        [Required]
        public string name { get; set; }
        [Required]
        public string password { get; set; }
    }
}
