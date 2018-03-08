using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class segmentlist : System.Web.UI.Page
{
    public static string CRM37Conn = ConfigurationManager.ConnectionStrings["CRM37Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindSegmentLists();
        }
    }

    public void bindSegmentLists()
    {
        DataTable dt = null;
        SqlDataAdapter da = null;
        try
        {
            using (var con = new SqlConnection(CRM37Conn))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "SELECT * FROM segment WHERE isactive = 1";
                    cmd.Connection = con;
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }
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

        if (dt.Rows.Count > 0)
        {
            rptSegemnLists.DataSource = dt;
            rptSegemnLists.DataBind();
        }
        else
        {
            rptSegemnLists.DataSource = null;
            rptSegemnLists.DataBind();
        }

    }

    protected void rptSegemnLists_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int SegemntId = Convert.ToInt32((e.Item.FindControl("hdnSegemntId") as HiddenField).Value);
            Label lblPersonCount = e.Item.FindControl("lblPersonCount") as Label;
            lblPersonCount.Text = Convert.ToString(GetPersonCOUNT(BuildSQL(SegemntId)));
            var rptcriteria = e.Item.FindControl("rptcriteria") as Repeater;
            rptcriteria.DataSource = GetCrieteriBySegmentId(SegemntId);
            rptcriteria.DataBind();
        }
    }

    public static DataTable GetCrieteriBySegmentId(int pksegment)
    {
        DataTable dtSegmentCriteria = new DataTable();
        String strQuery = "SELECT o.operation, p.paramname, c.condition, c.conditionalias, sd.filter, sd.sortkey FROM segmentdetail sd";
        strQuery += " INNER JOIN luOperation o ON o.pkoperation = sd.fkoperation";
        strQuery += " INNER JOIN luparam p ON p.pkparam = sd.fkparam";
        strQuery += " INNER JOIN luCondition c ON c.pkcondition = sd.fkcondition";
        strQuery += " WHERE sd.fksegment = @fksegment ORDER BY sd.sortkey ";

        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                cmd.Parameters.AddWithValue("@fksegment", pksegment);
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    sda.SelectCommand = cmd;
                    sda.Fill(dtSegmentCriteria);

                }
                con.Close();
                return dtSegmentCriteria;
            }
        }
    }

    public static int GetPersonCOUNT(string strSQLQuery)
    {
        DataTable dtSegmentCriteria = new DataTable();
        String strQuery = "SELECT COUNT(*) FROM person WHERE ";
        strQuery += strSQLQuery;
        int count = 0;
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
                count = (int)cmd.ExecuteScalar();
                con.Close();
            }
        }
        return count;
    }

    public string BuildSQL(int pksegment)
    {
        DataTable dtSegmentCriteria = new DataTable();
        String strQuery = "SELECT o.operation, p.param_fieldname, c.condition, sd.filter, sd.sortkey FROM segmentdetail sd";
        strQuery += " INNER JOIN luOperation o ON o.pkoperation = sd.fkoperation";
        strQuery += " INNER JOIN luparam p ON p.pkparam = sd.fkparam";
        strQuery += " INNER JOIN luCondition c ON c.pkcondition = sd.fkcondition";
        strQuery += " WHERE sd.fksegment = @fksegment ORDER BY sd.sortkey ";

        using (var con = new SqlConnection(CRM37Conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = strQuery;
                cmd.Connection = con;
                cmd.Parameters.AddWithValue("@fksegment", pksegment);
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    sda.SelectCommand = cmd;
                    sda.Fill(dtSegmentCriteria);

                }
                con.Close();
            }
        }

        string strSQL = "SELECT * FROM person WHERE";
        string strWhere = "";
        string strOperation = "";
        string strOperand = "";
        string strParamName = "";
        string strCondition = "";
        string strfilter = "";
        if (dtSegmentCriteria != null && dtSegmentCriteria.Rows.Count > 0)
        {

            for (int i = 0; i < dtSegmentCriteria.Rows.Count; i++)
            {
                strfilter = Convert.ToString(dtSegmentCriteria.Rows[i]["filter"]);
                strParamName = Convert.ToString(dtSegmentCriteria.Rows[i]["param_fieldname"]);
                strCondition = Convert.ToString(dtSegmentCriteria.Rows[i]["condition"]).ToLower();
                strOperation = Convert.ToString(dtSegmentCriteria.Rows[i]["operation"]);
                string[] strListOfFilter = null;
                if (strfilter.Contains(','))
                    strListOfFilter = strfilter.Trim().Split(',');

                if (i > 0)
                {
                    strWhere += " " + strOperation + " ";
                }

                if (strCondition == "is")
                {
                    strOperand = "= '{TEXT}'";
                }
                else if (strCondition == "isn't")
                {
                    strOperand = "<> '{TEXT}'";
                }
                else if (strCondition == "contains")
                {
                    strOperand = "LIKE '%{TEXT}%'";
                }
                else if (strCondition == "doesn't contain")
                {
                    strOperand = "NOT LIKE '%{TEXT}%'";
                }
                else if (strCondition == "starts with")
                {
                    strOperand = "LIKE '{TEXT}%'";
                }
                else if (strCondition == "ends with")
                {
                    strOperand = "LIKE '%{TEXT}'";
                }
                else if (strCondition == "between")
                {
                    strOperand = "BETWEEN '{0}' AND '{1}'";
                }

                if (strListOfFilter != null && strListOfFilter.Length > 0)
                {
                    strWhere += " ( ";
                    foreach (string str in strListOfFilter)
                    {
                        strWhere += strParamName + " " + strOperand.Replace("{TEXT}", str.Trim());
                        if (!strListOfFilter.LastOrDefault().Equals(str))
                        {
                            strWhere += " OR ";
                        }
                    }
                    strWhere += " ) ";
                }
                else
                {
                    if (strCondition == "between")
                    {
                        string[] strBetween = strfilter.Trim().Split('-');
                        strWhere += " " + strParamName + " " + string.Format(strOperand, strBetween[0].Trim(), strBetween[1].Trim());
                    }
                    else if (strCondition == "today")
                    {
                        strWhere += " " + strParamName + " = CONVERT(date,getdate())";
                    }
                    else if (strCondition == "last month")
                    {
                        strWhere += " " + strParamName + " >= DATEADD(month, -1,DATEADD(month, DATEDIFF(month, 0, CURRENT_TIMESTAMP), 0)) AND ";
                        strWhere += " " + strParamName + " < DATEADD(month, DATEDIFF(month, 0, CURRENT_TIMESTAMP), 0)";
                    }
                    else if (strCondition == "current month")
                    {
                        strWhere += " datepart(mm," + strParamName + ") = month(getdate()) AND datepart(yyyy," + strParamName + ") = year(getdate())";
                    }
                    else if (strCondition == "last week")
                    {
                        strWhere += " " + strParamName + " >= dateadd(wk, datediff(wk, 0, getdate()) - 1, 0) AND ";
                        strWhere += " " + strParamName + " < dateadd(wk, datediff(wk, 0, getdate()), 0)";
                    }
                    else if (strCondition == "current week")
                    {
                        strWhere += " " + strParamName + " >= dateadd(day, 1-datepart(dw, getdate()), CONVERT(date,getdate())) AND ";
                        strWhere += " " + strParamName + " < dateadd(day, 8-datepart(dw, getdate()), CONVERT(date,getdate()))";
                    }
                    else
                    {
                        strWhere += " " + strParamName + " " + strOperand.Replace("{TEXT}", strfilter.Trim());
                    }
                }

            }

        }
        return strWhere;
    }

    public void rptSegemnLists_OnItemCommand(Object Sender, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            int pksegemnt = Convert.ToInt32(e.CommandArgument);
            using (var con = new SqlConnection(CRM37Conn))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText = "UPDATE segment SET isdeleted = 1 , isactive = 0 WHERE pksegment = @pksegment";
                    cmd.Parameters.AddWithValue("@pksegment", pksegemnt);

                    cmd.Connection = con;

                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
            bindSegmentLists();
        }
    }
}