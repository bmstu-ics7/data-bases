using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace Lab06.Tables
{
    [Table(Name = "Stars.Scientists")]
    public class Scientists
    {
        [Column(Name = "ScientistId", IsDbGenerated = true)]
        public int ScientistId { get; set; }

        [Column(Name = "SName")]
        public string SName { get; set; }

        [Column(Name = "Century")]
        public int Century { get; set; }

        public override string ToString() => $"{this.ScientistId} {this.SName} {this.Century}";
    }
}
