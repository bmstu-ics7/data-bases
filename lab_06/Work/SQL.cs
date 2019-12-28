using System;
using System.Linq;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using Lab06.Tables;
using System.Reflection;

namespace Lab06.Work
{
    public class UserDataContext : DataContext
    {
        public UserDataContext(string connectionString) 
            :base(connectionString) { }

        public Table< Stars > stars { get { return this.GetTable< Stars >(); } }
 
        [Function(Name = "dbo.CountStarsOfType")]
        [return: Parameter(DbType = "Int")]
        public int CountStarsOfType([Parameter(Name = "TypeStar", DbType = "varchar(20)")] string TypeStar,
            [Parameter(Name = "Count", DbType = "Int")] ref int count)
        {
            IExecuteResult result = this.ExecuteMethodCall(
                    this,
                    ((MethodInfo)(MethodInfo.GetCurrentMethod())),
                    TypeStar,
                    count);
            count = ((int)(result.GetParameterValue(1)));
            return ((int)(result.ReturnValue));
        }
    }

    static public class SQL
    {
        static public Table< Constellations > consellations;
        static public Table< Scientists > scientists;
        static public Table< Countries > countries;
        static public Table< Stars > stars;
        static public Table< ExtraInfo > extraInfo;
        static public Table< CountriesStars > countriesStars;
        static public DataContext db;
        static public UserDataContext udb;

        static public void OneTableRequest()
        {
            Console.WriteLine("Однотаблиычный запрос: все звезды буквы альфа с видимым звездным значением большим 3");
            var result = stars
                .Where(s => s.SeeStarValue > 3 && s.Letter == "Alpha")
                .Select(s => new { Name = s.SName, SSV = s.SeeStarValue, Letter = s.Letter });

            Console.WriteLine("┌──────────────────────┬────────────┬──────┐");
            Console.WriteLine("│                  Name│SeeStarValue│Letter│");
            Console.WriteLine("├──────────────────────┼────────────┼──────┤");
            foreach (var el in result)
            {
                Console.WriteLine($"│{el.Name,22}│{el.SSV,12}│{el.Letter, 6}│");
            }
            Console.WriteLine("└──────────────────────┴────────────┴──────┘");
        }

        static public void MultiTalbeRequest()
        {
            Console.WriteLine("Многотабличный запрос: все звезды типа гигант с массой, меньшей 200");
            var result = stars
                .Join(extraInfo,
                      s => s.StarId,
                      e => e.StarId,
                      (s, e) => new { Name = s.SName, Type = e.TypeStar, Mass = e.Mass })
                .Where(o => o.Type == "Giant" && o.Mass < 200);

            Console.WriteLine("┌──────────────────────┬──────┬─────┐");
            Console.WriteLine("│                  Name│  Type│ Mass│");
            Console.WriteLine("├──────────────────────┼──────┼─────┤");
            foreach (var el in result)
            {
                Console.WriteLine($"│{el.Name,22}│{el.Type,6}│{el.Mass, 5}│");
            }
            Console.WriteLine("└──────────────────────┴──────┴─────┘");
        }

        static public void Add()
        {
            Stars star = new Stars();
            star.SName = "Kekekek";
            star.Letter = "Kek";
            star.RightAscension = 12;
            star.Declination = 70;
            star.SeeStarValue = 1;
            star.Color = "Blue";
            star.ConstellationId = 12;

            db.GetTable< Stars >().InsertOnSubmit(star);
            db.SubmitChanges();

            Console.WriteLine("Добавленный объект");
            foreach (var el in db.GetTable< Stars >().Where(s => s.Letter == "Kek"))
            {
                Console.WriteLine($"{el.SName} {el.Letter} {el.Declination}");
            }
        }

        static public void Edit()
        {
            var star = db.GetTable< Stars >().OrderByDescending(s => s.StarId).FirstOrDefault();

            if (star != null)
            {
                star.SName = "Changed!";
                db.SubmitChanges();

                Console.WriteLine("Измененный объект");
                foreach (var el in db.GetTable< Stars >().Where(s => s.Letter == "Kek"))
                {
                    Console.WriteLine($"{el.SName} {el.Letter} {el.Declination}");
                }
            }
        }

        static public void Delete()
        {
            var star = db.GetTable< Stars >().OrderByDescending(s => s.StarId).FirstOrDefault();
            if (star != null)
            {
                db.GetTable< Stars >().DeleteOnSubmit(star);
                db.SubmitChanges();

                Console.WriteLine("Удаленный объект:");
                foreach (var el in db.GetTable< Stars >().Where(s => s.Letter == "Kek"))
                {
                    Console.WriteLine($"{el.SName} {el.Letter} {el.Declination}");
                }
            }
        }

        static public void Procedure()
        {
            int count = 0;
            udb.CountStarsOfType("Dwarf", ref count);
            Console.WriteLine("Результат работы функции: ");
            Console.WriteLine(count);
        }
    }
}
