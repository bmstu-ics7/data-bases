using System;
using System.Linq;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace rk03
{
    [Table(Name = "Office")]
    public class Office
    {
        [Column(Name = "Id")]
        public int Id { get; set; }

        [Column(Name = "Name")]
        public string Name { get; set; }

        [Column(Name = "Adress")]
        public string Adress { get; set; }

        [Column(Name = "Telephone")]
        public string Telephone { get; set; }
    }

    [Table(Name = "Worker")]
    public class Worker
    {
        [Column(Name = "Id")]
        public int Id { get; set; }

        [Column(Name = "Name")]
        public string Name { get; set; }

        [Column(Name = "Birthday")]
        public DateTime Birthday { get; set; }

        [Column(Name = "Department")]
        public string Department { get; set; }

        [Column(Name = "OfficeId")]
        public int OfficeId { get; set; }
    }

    class Program
    {
        static void Main(string[] args)
        {
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = "localhost";
            builder.UserID = "sa";
            builder.Password = "myPassw0rd";
            builder.InitialCatalog = "RK3";

            DataContext db = new DataContext(builder.ConnectionString);
            SqlConnection connection = new SqlConnection(builder.ConnectionString);

            try
            {
                connection.Open();

                Table< Office > office = db.GetTable< Office >();
                foreach (var o in office)
                {
                    Console.WriteLine($"{o.Id} {o.Name} {o.Adress} {o.Telephone}");
                }
                Console.WriteLine();

                Table< Worker > worker = db.GetTable< Worker >();
                foreach (var w in worker)
                {
                    Console.WriteLine($"{w.Id} {w.Name} {w.Birthday} {w.Department} {w.OfficeId}");
                }
                Console.WriteLine();

                //
                //
                // Первый запрос SQL
                //
                //
                string sqlFirst =   "select Street, count(t) as Count\n" +
                                    "from (\n" +
                                    "    select substring(Adress, 0, charindex(',', Adress)) as Street, substring(Adress, 0, 1) as t\n" +
                                    "    from Office\n" +
                                    "    group by Adress\n" +
                                    ") as temp\n" +
                                    "group by Street\n";

                SqlCommand first = new SqlCommand(sqlFirst, connection);
                SqlDataReader firstReader = first.ExecuteReader();

                if(firstReader.HasRows)
                {
                    Console.WriteLine($"{firstReader.GetName(0)}\t\t{firstReader.GetName(1)}");
                    while (firstReader.Read())
                    {
                        object adress = firstReader.GetValue(0);
                        object count = firstReader.GetValue(1);
                        Console.WriteLine($"{adress}\t\t{count}");
                    }
                }
                Console.WriteLine();
                firstReader.Close();

                //
                //
                //
                // Первый запрос LINQ
                //
                //
                /*var firstTable = office.GroupBy(o => o.Adress.Split(new char[] { ',' }, 1))
                                       .Select(g => new { Street = g.Adress.Split(new char[] { ',' }, 1), Count = g.Count() });
                foreach (var f in firstTable)
                {
                    Console.WriteLine($"{f.Street} {f.Count}");
                }
                Console.WriteLine();*/

                //
                //
                //
                // Третий запрос SQL
                //
                //
                string sqlThird = "select W.Name, O.Name from Worker W join Office O on W.OfficeId = O.Id where charindex('7', O.Telephone) <= 0";

                SqlCommand third = new SqlCommand(sqlThird, connection);
                SqlDataReader thirdReader = third.ExecuteReader();

                if(thirdReader.HasRows)
                {
                    Console.WriteLine($"{thirdReader.GetName(0)}\t\t{thirdReader.GetName(1)}");
                    while (thirdReader.Read())
                    {
                        object work = thirdReader.GetValue(0);
                        object off = thirdReader.GetValue(1);
                        Console.WriteLine($"{work}\t\t{off}");
                    }
                }
                Console.WriteLine();
                thirdReader.Close();

                //
                //
                //
                // Третий запрос LINQ
                //
                //
                var thirdTable = office.Join(worker,
                                             o => o.Id,
                                             w => w.OfficeId,
                                             (o, w) => new { OName = o.Name, WName = w.Name, tel = o.Telephone })
                    .Where(obj => obj.tel.Count(c => c == '7') == 0);
                foreach (var t in thirdTable)
                {
                    Console.WriteLine($"{t.OName} {t.WName}");
                }
                Console.WriteLine();
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }
            finally
            {
                connection.Close();
            }
        }
    }
}
