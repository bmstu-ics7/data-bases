using System;
using System.Xml;
using System.Xml.Linq;

namespace Lab06.Work
{
    static public class XML
    {
        static public void Read()
        {
            string fileName = "document.xml";
            XDocument doc = XDocument.Load(fileName);
            foreach (XElement el in doc.Root.Elements())
            {
                Console.WriteLine("{0} -- {1}", el.Attribute("SName").Value, el.Attribute("Color").Value);
            }
        }

        static public void Edit()
        {
            string fileName = "document.xml";
            XDocument doc = XDocument.Load(fileName);
            XNode node = doc.Root.FirstNode;

            while (node != null)
            {
                if (node.NodeType == System.Xml.XmlNodeType.Element)
                {
                    XElement el = (XElement)node;
                    el.Attribute("Color").Value = "ThisWasEdit";
                }

                node = node.NextNode;
            }

            doc.Save(fileName);
        }

        static public void Add()
        {
            string fileName = "document.xml";
            XDocument doc = XDocument.Load(fileName);

            XElement star = new XElement("Stars.Stars",
                    new XAttribute("StarId", 0),
                    new XAttribute("Letter", "kek"),
                    new XAttribute("SName", "SuperStar"),
                    new XAttribute("RightAscension", 0),
                    new XAttribute("Declination", 0),
                    new XAttribute("SeeStarValue", 0),
                    new XAttribute("Color", "White"),
                    new XAttribute("ConstellationId", 0)
            );

            doc.Root.Add(star);
            doc.Save(fileName);
        }
    }
}
