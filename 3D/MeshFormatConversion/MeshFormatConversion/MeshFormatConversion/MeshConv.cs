using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MeshFormatConversion
{
    // wrapper for converting mesh file format
    class MeshConv
    {
        private string executablePath = "meshconv.exe";

        public bool BatchConvertPricetonModels(string db_folder, string res_folder, string targetFormat)
        {
            string[] folders = Directory.GetDirectories(db_folder);
            for (int i = 0; i < folders.Length; i++)
            {
                string[] sub_folders = Directory.GetDirectories(folders[i]);
                for (int j = 0; j < sub_folders.Length; j++)
                {
                    string[] model_files = Directory.GetFiles(sub_folders[j], "*.off");
                    for (int k = 0; k < model_files.Length; k++)
                    {
                        string output_file = res_folder + Path.GetFileNameWithoutExtension(model_files[k]) + ".obj";
                        Process detector = new Process();
                        try
                        {
                            detector.StartInfo.UseShellExecute = false;
                            detector.StartInfo.FileName = executablePath;
                            detector.StartInfo.Arguments = model_files[k] + " -c obj -tri -o " + output_file;
                            detector.StartInfo.CreateNoWindow = true;
                            detector.Start();
                            detector.WaitForExit();
                            Console.WriteLine("Converted " + model_files[k]);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                        }
                    }
                }
            }

            return true;
        }

        // format: "off", "obj"
        public void BatchConvertModelNet(string model_list_file, string data_root, string srcFormat, string targetFormat)
        {
             // load model files from list file
            using(StreamReader reader = new StreamReader(model_list_file))
            {
                string list_str = reader.ReadToEnd();
                char[] delimiters = {'\n'};
                string[] all_fns = list_str.Split(delimiters);
                foreach (string fn in all_fns)
                {
                    string new_fn = fn.TrimEnd(new []{'\r'});
                    string src_model_fn = data_root + new_fn + "." + srcFormat;
                    string des_model_fn = data_root + new_fn;
                    if (File.Exists(des_model_fn + "." + targetFormat))
                        continue;
                    Process detector = new Process();
                    try
                    {
                        detector.StartInfo.UseShellExecute = false;
                        detector.StartInfo.FileName = executablePath;
                        detector.StartInfo.Arguments = src_model_fn + " -c " + targetFormat + " -tri -o " + des_model_fn;
                        detector.StartInfo.CreateNoWindow = false;
                        detector.Start();
                        detector.WaitForExit();
                        Console.WriteLine("Converted " + src_model_fn);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }
            }
        }
    }
}
