using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSharpProcessor
{
    // wrapper for converting mesh file format
    // hard-coded for Priceton shape dataset, but you get the idea
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
    }
}
