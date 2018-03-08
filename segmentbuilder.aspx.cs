using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using Newtonsoft.Json;

public partial class segmentbuilder : System.Web.UI.Page
{
    public static string CRM37Conn = ConfigurationManager.ConnectionStrings["CRM37Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                string segmentdetails = FillSegemntDeatil(Convert.ToInt32(Request.QueryString["id"]));
                hdfMode.Value = "edit";
                hdnpksegment.Value = Convert.ToString(Request.QueryString["id"]);
                ltrTitle.Text = "Edit Segment";
                bool IsRecordFound = false;
                using (var con = new SqlConnection(CRM37Conn))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "SELECT * FROM segment WHERE pksegment = @pksegment AND isactive = 1";
                        cmd.Connection = con;
                        cmd.Parameters.AddWithValue("@pksegment", Convert.ToString(Request.QueryString["id"]));
                        if (con.State == ConnectionState.Closed)
                        {
                            con.Open();
                        }
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.Read())
                        {
                            IsRecordFound = true;
                            txtName.Text = Convert.ToString(sdr["segmentname"]);
                        }
                        sdr.Close();
                    }
                }

                if (!IsRecordFound)
                {
                    Response.Redirect("segmentlist.aspx");
                }

            }

        }

    }

    public static string FillSegemntDeatil(int pksegemnt)
    {
        DataTable dt = null;
        SqlDataAdapter da = null;
        string segmentListInJSON = "";
        try
        {
            using (var con = new SqlConnection(CRM37Conn))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    string strQuery = "SELECT sd.*,pt.paramtype, c.condition FROM segmentdetail sd";
                    strQuery += " INNER JOIN segment s ON s.pksegment = sd.fksegment";
                    strQuery += " INNER JOIN luparam p ON p.pkparam = sd.fkparam";
                    strQuery += " INNER JOIN luParamType pt ON pt.pkparamtype = p.fkparamtype";
                    strQuery += " INNER JOIN luCondition c ON c.pkcondition = sd.fkcondition";
                    strQuery += " WHERE sd.fksegment = @fksegment AND s.isactive = 1 ORDER BY sd.sortkey";

                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = strQuery;
                    cmd.Connection = con;
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }
                    cmd.Parameters.AddWithValue("@fksegment", pksegemnt);
                    dt = new DataTable();
                    da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }
        }
        catch (Exception ef)
        {
            //handle Exception
        }
        finally
        {
            if (da != null) da.Dispose();
        }

        if (dt != null && dt.Rows.Count > 0)
        {
            segmentListInJSON = GetJson(dt);
        }

        return segmentListInJSON;
    }

    public static string GetJson(DataTable dt)
    {
        System.Web.Script.Serialization.JavaScriptSerializer serializer = new

        System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> rows =
          new List<Dictionary<string, object>>();
        Dictionary<string, object> row = null;

        foreach (DataRow dr in dt.Rows)
        {
            row = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                row.Add(col.ColumnName.Trim(), dr[col]);
            }
            rows.Add(row);
        }
        return serializer.Serialize(rows);
    }

    [System.Web.Services.WebMethod]
    public static ArrayList PopulateParameter()
    {
        ArrayList list = new ArrayList();
        String strQuery = "SELECT pkparam, paramname from luParam WHERE isactive = 1 ORDER BY sortkey";
        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    list.Add(new ListItem(
                   sdr["pkparam"].ToString(),
                   sdr["paramname"].ToString()
                    ));
                }
                sdr.Close();
                con.Close();
                return list;
            }
        }
    }

    [System.Web.Services.WebMethod]
    public static ArrayList PopulateParameterValues(int pkparam)
    {
        ArrayList list = new ArrayList();

        string strParamFieldName = "";
        int fkparamtype = 0;
        String strQuery = "select param_fieldname, fkparamtype from luparam where pkparam = @pkparam";
        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                cmd.Parameters.AddWithValue("@pkparam", pkparam);
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.Read())
                {
                    strParamFieldName = Convert.ToString(sdr["param_fieldname"]);
                    fkparamtype = Convert.ToInt32(sdr["fkparamtype"]);
                }

                con.Close();
            }
        }

        if (fkparamtype == 1) //if param type is string then need to fill list box with values
        {
            String strQueryParam = "SELECT DISTINCT " + strParamFieldName + " as Params FROM person WHERE " + strParamFieldName + " IS NOT NULL ORDER BY " + strParamFieldName;
            using (var con = new SqlConnection(CRM37Conn))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = strQueryParam;
                    cmd.Connection = con;
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }
                    SqlDataReader sdr = cmd.ExecuteReader();
                    while (sdr.Read())
                    {
                        list.Add(new ListItem(
                       sdr["Params"].ToString(),
                       sdr["Params"].ToString()
                        ));
                    }
                    sdr.Close();
                    con.Close();

                }
            }
        }
        return list;
    }

    [System.Web.Services.WebMethod]
    public static ArrayList PopulateOperation()
    {
        ArrayList list = new ArrayList();
        String strQuery = "SELECT pkoperation, operation from luOperation WHERE isactive = 1";
        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    list.Add(new ListItem(
                   sdr["pkoperation"].ToString(),
                   sdr["operation"].ToString()
                    ));
                }
                sdr.Close();
                con.Close();
                return list;
            }
        }
    }

    [System.Web.Services.WebMethod]
    public static ArrayList PopulateCondition(int pkparam)
    {
        ArrayList list = new ArrayList();
        String strQuery = "select pkcondition, condition from lucondition where fkparamtype = (select fkparamtype from luparam WHERE pkparam = @pkparam)";
        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.AddWithValue("@pkparam", pkparam);
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    list.Add(new ListItem(
                   sdr["pkcondition"].ToString(),
                   sdr["condition"].ToString()
                    ));
                }
                sdr.Close();
                con.Close();
                return list;
            }
        }
    }

    [System.Web.Services.WebMethod]
    public static string GetParamType(int pkcondition)
    {
        String strQuery = "select paramtype from luParamType where pkparamtype = (select fkparamtype from lucondition WHERE pkcondition = @pkcondition)";
        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.AddWithValue("@pkcondition", pkcondition);
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                string paramtype = Convert.ToString(cmd.ExecuteScalar());

                con.Close();
                return paramtype;
            }
        }
    }

    [System.Web.Services.WebMethod]
    public static string GetSegmentDetailInJSON(int pksegment)
    {
        return FillSegemntDeatil(pksegment);
    }

    [System.Web.Services.WebMethod]
    public static string SaveSegment(string segmentname, string segmentdata, int pksegment)
    {
        var serializeData = JsonConvert.DeserializeObject<List<segmentdetail>>(segmentdata);

        //get list of all active parameter type
        Dictionary<int, string> list = new Dictionary<int, string>();
        String strQuery = "SELECT c.pkcondition, pt.paramtype FROM lucondition c INNER JOIN luParamType pt ON pt.pkparamtype = c.fkparamtype";
        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    list.Add(Convert.ToInt32(sdr["pkcondition"]), sdr["paramtype"].ToString());
                }
                sdr.Close();
                con.Close();
            }
        }

        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                if (pksegment == 0)
                {
                    cmd.CommandText = "INSERT INTO segment (fksegmentstatus, segmentname) VALUES(@fksegmentstatus, @segmentname) SELECT CAST(scope_identity() AS int)";
                    cmd.Parameters.AddWithValue("@fksegmentstatus", 0);
                    cmd.Parameters.AddWithValue("@segmentname", segmentname);
                }
                else
                {
                    cmd.CommandText = "UPDATE segment SET fksegmentstatus = @fksegmentstatus, segmentname = @segmentname WHERE pksegment = @pksegment";
                    cmd.Parameters.AddWithValue("@fksegmentstatus", 0);
                    cmd.Parameters.AddWithValue("@segmentname", segmentname);
                    cmd.Parameters.AddWithValue("@pksegment", pksegment);
                }
                cmd.Connection = con;

                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                if (pksegment == 0)
                    pksegment = (int)cmd.ExecuteScalar();
                else
                    cmd.ExecuteNonQuery();
                con.Close();
            }
        }
        if (pksegment > 0)
        {
            using (var con = new SqlConnection(CRM37Conn))
            {
                int sortkey = 0;
                string strIDsOfSegemntDetails = "";
                foreach (var data in serializeData)
                {
                    using (var cmd = new SqlCommand())
                    {
                        sortkey = sortkey + 1;
                        cmd.CommandType = CommandType.Text;
                        cmd.Connection = con;
                        if (pksegment == 0 || data.pksegmentdetail == 0)
                        {
                            cmd.CommandText = "INSERT INTO segmentdetail (fksegment, fkoperation,fkparam,fkcondition,sortkey,filter) VALUES(@fksegment, @fkoperation,@fkparam,@fkcondition,@sortkey,@filter) SELECT CAST(scope_identity() AS int)";
                            cmd.Parameters.AddWithValue("@fksegment", pksegment);
                            cmd.Parameters.AddWithValue("@fkoperation", data.fkoperation);
                            cmd.Parameters.AddWithValue("@fkparam", data.fkparam);
                            cmd.Parameters.AddWithValue("@fkcondition", data.fkcondition);
                            cmd.Parameters.AddWithValue("@sortkey", sortkey);

                        }
                        else
                        {
                            cmd.CommandText = "UPDATE segmentdetail SET fksegment = @fksegment, fkoperation = @fkoperation,fkparam = @fkparam,fkcondition = @fkcondition,sortkey = @sortkey,filter = @filter WHERE pksegmentdetail = @";
                            cmd.Parameters.AddWithValue("@fksegment", pksegment);
                            cmd.Parameters.AddWithValue("@fkoperation", data.fkoperation);
                            cmd.Parameters.AddWithValue("@fkparam", data.fkparam);
                            cmd.Parameters.AddWithValue("@fkcondition", data.fkcondition);
                            cmd.Parameters.AddWithValue("@sortkey", sortkey);
                        }

                        if (list[data.fkcondition] == "string")
                        {
                            cmd.Parameters.AddWithValue("@filter", data.string_filter_value);
                        }
                        else if (list[data.fkcondition] == "date")
                        {
                            if (data.fkcondition == 12)
                            {
                                cmd.Parameters.AddWithValue("@filter", data.txtRangeDate);
                            }
                            else if (data.fkcondition >= 13 && data.fkcondition <= 17)
                            {
                                cmd.Parameters.AddWithValue("@filter", data.string_filter_value);
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue("@filter", data.txtDate);
                            }

                        }

                        if (con.State == ConnectionState.Closed)
                        {
                            con.Open();
                        }

                        if (pksegment == 0 || data.pksegmentdetail == 0)
                        {
                            if (pksegment > 0)
                            {
                                int pksegmentdetail = (int)cmd.ExecuteScalar();
                                strIDsOfSegemntDetails += pksegmentdetail + ",";
                            }
                            else
                            {
                                cmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@pksegmentdetail", data.pksegmentdetail);
                            strIDsOfSegemntDetails += data.pksegmentdetail + ",";
                            cmd.ExecuteNonQuery();
                        }

                    }

                    //delete those segemnt criteria which are deleted while updating
                    if (pksegment > 0 && strIDsOfSegemntDetails.Length > 0)
                    {
                        using (var cmd = new SqlCommand())
                        {
                            cmd.CommandType = CommandType.Text;
                            cmd.CommandText = "DELETE FROM segmentdetail WHERE pksegmentdetail NOT IN (" + strIDsOfSegemntDetails.Trim(',') + ") AND fksegment = @fksegment";
                            cmd.Parameters.AddWithValue("@fksegment", pksegment);
                            cmd.Connection = con;
                            if (con.State == ConnectionState.Closed)
                            {
                                con.Open();
                            }
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        return "inserted";

    }
}

public class segmentdetail
{
    public int pksegmentdetail { get; set; }
    public int fkoperation { get; set; }
    public int fkparam { get; set; }
    public int fkcondition { get; set; }
    public string string_filter_value { get; set; }
    public string txtDate { get; set; }
    public string txtRangeDate { get; set; }
}