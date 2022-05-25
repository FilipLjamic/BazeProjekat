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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text == "" || textBox2.Text == "")
            {
                MessageBox.Show("Unesite email i lozinku.");
                return;
            }
            else
            {
                try
                {
                    SqlConnection veza = Konekcija.Connect();
                    SqlCommand komanda = new SqlCommand("SELECT * FROM Korisnik WHERE Mejl = @mejl", veza);
                    komanda.Parameters.AddWithValue("@mejl", textBox1.Text);
                    SqlDataAdapter adapter = new SqlDataAdapter(komanda);
                    DataTable tabela = new DataTable();
                    adapter.Fill(tabela);
                    int brojac = tabela.Rows.Count;
                    if (brojac == 1)
                    {
                        if (String.Compare(tabela.Rows[0]["Lozinka"].ToString(), textBox2.Text) == 0)
                        {
                            MessageBox.Show("Uspesan login");
                            Program.user_ime = tabela.Rows[0]["Ime"].ToString();
                            Program.user_prezime = tabela.Rows[0]["Prezime"].ToString();
                            Program.user_uloga = (bool)tabela.Rows[0]["jeAdmin"];
                            this.Hide();
                            Form2 frm_2 = new Form2();
                            frm_2.Show();
                        }
                        else
                        {
                            MessageBox.Show("Neispravna lozinka");
                        }
                    }
                    else
                    {
                        MessageBox.Show("Nepostojeci E-mail.");
                    }
                }
                catch (Exception greska)
                {
                    MessageBox.Show(greska.Message);
                }
            }
        }
    }
}
