﻿namespace SonSer
{
    partial class SonSer
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnFindSong = new System.Windows.Forms.Button();
            this.btnPlayPause = new System.Windows.Forms.Button();
            this.txt_spotid = new System.Windows.Forms.TextBox();
            this.btn_findbyid = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnFindSong
            // 
            this.btnFindSong.Location = new System.Drawing.Point(5, 33);
            this.btnFindSong.Name = "btnFindSong";
            this.btnFindSong.Size = new System.Drawing.Size(75, 23);
            this.btnFindSong.TabIndex = 2;
            this.btnFindSong.Text = "Find Song";
            this.btnFindSong.UseVisualStyleBackColor = true;
            this.btnFindSong.Click += new System.EventHandler(this.btnFindSong_Click);
            // 
            // btnPlayPause
            // 
            this.btnPlayPause.Location = new System.Drawing.Point(5, 62);
            this.btnPlayPause.Name = "btnPlayPause";
            this.btnPlayPause.Size = new System.Drawing.Size(75, 23);
            this.btnPlayPause.TabIndex = 3;
            this.btnPlayPause.Text = "Play/Pause";
            this.btnPlayPause.UseVisualStyleBackColor = true;
            this.btnPlayPause.Click += new System.EventHandler(this.btnPlayPause_Click);
            // 
            // txt_spotid
            // 
            this.txt_spotid.Location = new System.Drawing.Point(86, 92);
            this.txt_spotid.Name = "txt_spotid";
            this.txt_spotid.Size = new System.Drawing.Size(100, 20);
            this.txt_spotid.TabIndex = 4;
            // 
            // btn_findbyid
            // 
            this.btn_findbyid.Location = new System.Drawing.Point(5, 89);
            this.btn_findbyid.Name = "btn_findbyid";
            this.btn_findbyid.Size = new System.Drawing.Size(75, 23);
            this.btn_findbyid.TabIndex = 5;
            this.btn_findbyid.Text = "Find by ID";
            this.btn_findbyid.UseVisualStyleBackColor = true;
            this.btn_findbyid.Click += new System.EventHandler(this.btn_findbyid_Click);
            // 
            // SonSer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(527, 306);
            this.Controls.Add(this.btn_findbyid);
            this.Controls.Add(this.txt_spotid);
            this.Controls.Add(this.btnPlayPause);
            this.Controls.Add(this.btnFindSong);
            this.Name = "SonSer";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnFindSong;
        private System.Windows.Forms.Button btnPlayPause;
        private System.Windows.Forms.TextBox txt_spotid;
        private System.Windows.Forms.Button btn_findbyid;
    }
}
