using System;
using System.Linq;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using Lab06.Tables;

namespace Lab06.Work
{
    static public class Linq
    {
        static public void Request1()
        {
            Console.WriteLine("Первый запрос: все карлики, у которых радиус больше 1e+7");
            var result = SQL.stars.Join(SQL.extraInfo,
                                        s => s.StarId,
                                        e => e.StarId,
                                        (s, e) => new { Id = s.StarId, Name = s.SName, Radius = e.Radius, Type = e.TypeStar })
                        .Where(o => o.Type == "Dwarf" && o.Radius >= 1e+7);

            Console.WriteLine("┌───┬──────────────────────┬──────────┬──────┐");
            Console.WriteLine("│ Id│                  Name│    Radius│  Type│");
            Console.WriteLine("├───┼──────────────────────┼──────────┼──────┤");
            foreach (var el in result)
            {
                Console.WriteLine($"│{el.Id,3}│{el.Name,22}│{el.Radius, 10}│{el.Type, 6}│");
            }
            Console.WriteLine("└───┴──────────────────────┴──────────┴──────┘");
        }

        static public void Request2()
        {
            Console.WriteLine("Второй запрос: количество типов звезд");
            var result = SQL.stars.Join(SQL.extraInfo,
                                        s => s.StarId,
                                        e => e.StarId,
                                        (s, e) => new { Type = e.TypeStar, Id = s.StarId })
                            .GroupBy(o => o.Type)
                            .Select(o => new { Type = o.Key, Count = o.Count() });

            Console.WriteLine("┌──────────┬─────┐");
            Console.WriteLine("│      Type│Count│");
            Console.WriteLine("├──────────┼─────┤");
            foreach (var el in result)
            {
                Console.WriteLine($"│{el.Type, 10}│{el.Count, 5}│");
            }
            Console.WriteLine("└──────────┴─────┘");
        }

        static public void Request3()
        {
            Console.WriteLine("Третий запрос: Количество звезд, видимое в каждой стране");
            var tmp = SQL.countriesStars.GroupBy(c => c.CountryId)
                                        .Select(o => new { CId = o.Key, Count = o.Count() });
            var result = SQL.countries.Join(tmp,
                                            c => c.CountryId,
                                            t => t.CId,
                                            (c, t) => new { Name = c.CName, t.Count });

            Console.WriteLine("┌────────────────────────────┬─────┐");
            Console.WriteLine("│                     Country│Count│");
            Console.WriteLine("├────────────────────────────┼─────┤");
            foreach (var el in result)
            {
                Console.WriteLine($"│{el.Name, 28}│{el.Count, 5}│");
            }
            Console.WriteLine("└────────────────────────────┴─────┘");
        }

        static public void Request4()
        {
            Console.WriteLine("Четвертый запрос: вывести список стран, в которых виден Сириус и сколько дней его видно");

            var sirius = SQL.stars.Where(s => s.SName == "Sirius");
            var result = SQL.countriesStars.Join(sirius,
                                                c => c.StarId,
                                                s => s.StarId,
                                                (c, s) => new { CId = c.CountryId, Days = c.DaysInYear })
                                            .Join(SQL.countries,
                                                  o => o.CId,
                                                  c => c.CountryId,
                                                  (o, c) => new { Name = c.CName, Days = o.Days });

            Console.WriteLine("┌────────────────────────────┬─────┐");
            Console.WriteLine("│                     Country│ Days│");
            Console.WriteLine("├────────────────────────────┼─────┤");
            foreach (var el in result)
            {
                Console.WriteLine($"│{el.Name, 28}│{el.Days, 5}│");
            }
            Console.WriteLine("└────────────────────────────┴─────┘");
        }

        static public void Request5()
        {
            Console.WriteLine("Пятый запрос: Среднее значение масс всех звезд");
            var result = SQL.extraInfo.Select(e => e.Mass).Average();
            Console.WriteLine(result);
        }
    }
}
