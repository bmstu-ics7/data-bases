using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace Lab06.Tables
{
    [Table(Name = "Stars.Stars")]
    public class Stars
    {
        [Column(Name = "StarId", IsDbGenerated = true, IsPrimaryKey = true)]
        public int StarId { get; set; }

        [Column(Name = "Letter")]
        public string Letter { get; set; }

        [Column(Name = "SName")]
        public string SName { get; set; }

        [Column(Name = "RightAscension")]
        public double RightAscension { get; set; }

        [Column(Name = "Declination")]
        public double Declination { get; set; }

        private double? _SeeStarValue;

        [Column(Name = "SeeStarValue")]
        public double? SeeStarValue
        {
            get => _SeeStarValue != null ? _SeeStarValue : 0;
            set => _SeeStarValue = value;
        }

        [Column(Name = "Color")]
        public string Color { get; set; }

        [Column(Name = "ConstellationId")]
        public int ConstellationId { get; set; }

        public override string ToString() => $"{this.StarId} {this.Letter} {this.SName} {this.RightAscension} {this.Declination} {this.SeeStarValue} {this.Color} {this.ConstellationId}";
    }
}
