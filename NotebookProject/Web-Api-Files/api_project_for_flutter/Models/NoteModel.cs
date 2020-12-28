using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace api_project_for_flutter.Models
{
    public class NoteModel
    {
        public int Id { get; set; }
        [Required]
        public int userId { get; set; }
        [Required]
        public string note  { get; set; }

    }
}
