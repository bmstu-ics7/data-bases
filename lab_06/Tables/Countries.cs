using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace Lab06.Tables
{
    [Table(Name = "Stars.Countries")]
    public class Countries
    {
        [Column(Name = "CountryId", IsDbGenerated = true)]
        public int CountryId { get; set; }

        [Column(Name = "CName")]
        public string CName { get; set; }

        public override string ToString() => $"{this.CountryId} {this.CName}";
    }
}
