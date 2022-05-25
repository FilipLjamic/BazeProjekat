using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace BazeProjekat
{
    public partial class Form2 : Form
    {
        DataTable dtProizvod;
        public Form2()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            GridPopulate();
            if (dtProizvod.Rows.Count > 0)
                txtPopulate(0);
        }

        private void GridPopulate()
        {
            string naredba = "SELECT Id, Naziv, Opis, Cena, Kolicina FROM Proizvod";
            SqlConnection veza = Konekcija.Connect();
            SqlDataAdapter adapter = new SqlDataAdapter(naredba.ToString(), veza);
            dtProizvod = new DataTable();
            adapter.Fill(dtProizvod);
            dataGridView1.DataSource = dtProizvod;
            dataGridView1.AllowUserToAddRows = false;
        }

        private void Form2_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void txtPopulate(int brsloga)
        {
            textBox1.Text = dtProizvod.Rows[brsloga]["Id"].ToString();
            textBox2.Text = dtProizvod.Rows[brsloga]["Naziv"].ToString();
            richTextBox1.Text = dtProizvod.Rows[brsloga]["Opis"].ToString();
            textBox3.Text = dtProizvod.Rows[brsloga]["Cena"].ToString();
            textBox4.Text = dtProizvod.Rows[brsloga]["Kolicina"].ToString();
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                txtPopulate(e.RowIndex);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            SqlConnection veza = Konekcija.Connect();
            StringBuilder naredba = new StringBuilder("INSERT INTO Proizvod (Naziv, Opis, Cena, Kolicina) VALUES('");
            naredba.Append(textBox2.Text.ToString() + "', '");
            naredba.Append(richTextBox1.Text.ToString() + "', '");
            naredba.Append(Convert.ToInt32(textBox3.Text) + "', '");
            naredba.Append(Convert.ToInt32(textBox4.Text) + "')");
            SqlCommand Komanda = new SqlCommand(naredba.ToString(), veza);
            try
            {
                veza.Open();
                Komanda.ExecuteNonQuery();
                veza.Close();
            }
            catch (Exception Greska)
            {
                MessageBox.Show(Greska.Message);
            }

            GridPopulate();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(textBox1.Text) > 0)
            {
                string naredba = "DELETE FROM Proizvod WHERE Id = " + textBox1.Text;
                SqlConnection veza = Konekcija.Connect();
                SqlCommand Komanda = new SqlCommand(naredba, veza);
                try
                {
                    veza.Open();
                    Komanda.ExecuteNonQuery();
                    veza.Close();
                    GridPopulate();
                    txtPopulate(0);
                }
                catch (Exception Greska)
                {
                    MessageBox.Show(Greska.Message);
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(textBox1.Text) > 0)
            {
                StringBuilder naredba = new StringBuilder("UPDATE Proizvod SET ");
                naredba.Append(" Naziv = '" + textBox2.Text.ToString() + "', ");
                naredba.Append(" Opis = '" + richTextBox1.Text.ToString() + "', ");
                naredba.Append(" Kolicina = '" + Convert.ToInt32(textBox3.Text) + "', ");
                naredba.Append(" Cena = '" + Convert.ToInt32(textBox4.Text) + "' ");
                naredba.Append(" WHERE Id = " + textBox1.Text);
                SqlConnection veza = Konekcija.Connect();
                SqlCommand Komanda = new SqlCommand(naredba.ToString(), veza);
                try
                {
                    veza.Open();
                    Komanda.ExecuteNonQuery();
                    veza.Close();
                }
                catch (Exception Greska)
                {
                    MessageBox.Show(Greska.Message);
                }
                GridPopulate();
            }
        }
    }
}
