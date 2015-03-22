using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MeshFormatConversion
{
    class Program
    {
        public static string model_list_fn = @"F:\3D\ModelNet\model_list.txt";
        public static string model_root = "F:/3D/ModelNet/full/";

        static void Main(string[] args)
        {
            //ProduceModelList();
            //return;

            MeshConv convertor = new MeshConv();        
            convertor.BatchConvertModelNet(model_list_fn, "", "off", "obj");
        }

        public static void ProduceModelList()
        {
            StringBuilder str = new StringBuilder();
            string[] all_dirs = Directory.GetDirectories(model_root);
            foreach (var curdir in all_dirs)
            {
                string[] obj_dirs = Directory.GetDirectories(curdir);
                foreach (var objdir in obj_dirs)
                {
                    string[] offfn = Directory.GetFiles(objdir, "*.off");
                    foreach (var fn in offfn)
                    {
                        // remove extension
                        var newfn = fn.Remove(fn.Length - 4);
                        str.AppendLine(newfn);
                    }
                }
            }
            using (StreamWriter writer = new StreamWriter(model_list_fn))
            {
                writer.Write(str.ToString());
            }
            Console.WriteLine("done.");
        }
    }
}
