using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MeshFormatConversion
{
    class Program
    {
        static void Main(string[] args)
        {
            MeshConv convertor = new MeshConv();
            string model_list_fn = @"F:\3D\ModelNet\model_list.txt";
            convertor.BatchConvertModelNet(model_list_fn, "F:/3D/ModelNet/full/", "off", "obj");
        }
    }
}
