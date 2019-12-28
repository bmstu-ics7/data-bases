using System;
using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace Lab06.Tables
{
    [Table(Name = "Stars.ExtraInfo")]
    public class ExtraInfo
    {
        [Column(Name = "StarId", IsDbGenerated = true)]
        public int StarId { get; set; }

        [Column(Name = "TypeStar")]
        public string TypeStar { get; set; }

        private int? _Distance { get; set; }

        [Column(Name = "Distance")]
        public int? Distance
        {
            get => _Distance != null ? _Distance : 0;
            set => _Distance = value;
        }

        private int? _Mass;

        [Column(Name = "Mass")]
        public int? Mass
        {
            get => _Mass != null ? _Mass : 0;
            set => _Mass = value;
        }

        private Int64? _Radius;

        [Column(Name = "Radius")]
        public Int64? Radius
        {
            get => _Radius != null ? _Radius : 0;
            set => _Radius = value;
        }

        private double? _AbsStarValue;

        [Column(Name = "AbsStarValue")]
        public double? AbsStarValue
        {
            get => _AbsStarValue != null ? _AbsStarValue : 0;
            set => _AbsStarValue = value;
        }

        private int? _Temperature;

        [Column(Name = "Temperature")]
        public int? Temperature
        {
            get => _Temperature != null ? _Temperature : 0;
            set => _Temperature = value;
        }

        private int? _ScientistId;

        [Column(Name = "ScientistId")]
        public int? ScientistId
        {
            get => _ScientistId != null ? _ScientistId : 0;
            set => _ScientistId = value;
        }

        public override string ToString() => $"{this.StarId} {this.TypeStar} {this.Distance} {this.Mass} {this.Radius} {this.AbsStarValue} {this.Temperature} {this.ScientistId}";
    }
}
