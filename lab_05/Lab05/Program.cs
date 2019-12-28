using System;
using System.Xml;
using System.Xml.Schema;

namespace Lab05
{
    class Program
    {
        static void SettingsValidationEventHandler(object sender, ValidationEventArgs e)
        {
            if (e.Severity == XmlSeverityType.Warning)
            {
                Console.Write("WARNING: ");
                Console.WriteLine(e.Message);
            }
            else if (e.Severity == XmlSeverityType.Error)
            {
                Console.Write("ERROR: ");
                Console.WriteLine(e.Message);
            }
        }

        static void Main(string[] args)
        {
            try
            {
                XmlReaderSettings Settings = new XmlReaderSettings();
                Settings.Schemas.Add("", "../document.xsd");
                Settings.ValidationType = ValidationType.Schema;
                Settings.ValidationEventHandler += new ValidationEventHandler(SettingsValidationEventHandler);

                XmlReader Scientists = XmlReader.Create("../document.xml", Settings);

                while (Scientists.Read());

                Console.WriteLine("Complete");
            }
            catch (XmlException e)
            {
                Console.WriteLine(e.Message);
                Console.WriteLine("FAILED");
            }
        }
    }
}
