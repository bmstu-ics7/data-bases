using System;
using System.Linq;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using Lab06.Tables;

namespace Lab06
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = "localhost";
            builder.UserID = "sa";
            builder.Password = "myPassw0rd";
            builder.InitialCatalog = "StarSkyDB";

            Work.SQL.db = new DataContext(builder.ConnectionString);
            Work.SQL.db.ObjectTrackingEnabled = true;
            Work.SQL.udb = new Work.UserDataContext(builder.ConnectionString);

            try
            {
                Work.SQL.consellations =  Work.SQL.db.GetTable< Constellations >();
                Work.SQL.scientists =     Work.SQL.db.GetTable< Scientists >();
                Work.SQL.countries =      Work.SQL.db.GetTable< Countries >();
                Work.SQL.stars =          Work.SQL.db.GetTable< Stars >();
                Work.SQL.extraInfo =      Work.SQL.db.GetTable< ExtraInfo >();
                Work.SQL.countriesStars = Work.SQL.db.GetTable< CountriesStars >();

                Work.Linq.Request1();
                Work.Linq.Request2();
                Work.Linq.Request3();
                Work.Linq.Request4();
                Work.Linq.Request5();

                Work.XML.Read();
                Work.XML.Edit();
                Work.XML.Add();

                Work.SQL.OneTableRequest();
                Work.SQL.MultiTalbeRequest();
                Work.SQL.Add();
                Work.SQL.Edit();
                Work.SQL.Delete();
                Work.SQL.Procedure();
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }
        }
    }
}
