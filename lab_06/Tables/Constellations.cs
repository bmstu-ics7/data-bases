using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace Lab06.Tables
{
    [Table(Name = "Stars.Constellations")]
    public class Constellations
    {
        [Column(Name = "ConstellationId", IsDbGenerated = true)]
        public int ConstellationId { get; set; }

        [Column(Name = "CName")]
        public string CName { get; set; }

        public override string ToString() => $"{this.ConstellationId} {this.CName}";
    }
}
