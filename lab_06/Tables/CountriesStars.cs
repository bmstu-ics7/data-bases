using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace Lab06.Tables
{
    [Table(Name = "Stars.CountriesStars")]
    public class CountriesStars
    {
        [Column(Name = "StarId", IsDbGenerated = true)]
        public int StarId { get; set; }

        [Column(Name = "CountryId")]
        public int CountryId { get; set; }

        [Column(Name = "DaysInYear")]
        public int DaysInYear { get; set; }

        public override string ToString() => $"{this.StarId} {this.CountryId} {this.DaysInYear}";
    }
}
