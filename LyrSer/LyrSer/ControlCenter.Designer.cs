namespace LyrSer
{
    partial class ControlCenter
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
            this.btnReadText = new System.Windows.Forms.Button();
            this.lblStatus = new System.Windows.Forms.Label();
            this.rtLyrics = new System.Windows.Forms.RichTextBox();
            this.lblConfidence = new System.Windows.Forms.Label();
            this.rtMatched = new System.Windows.Forms.RichTextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.Label5 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.lblGenre = new System.Windows.Forms.Label();
            this.lblEvilness = new System.Windows.Forms.Label();
            this.lblMsg = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.lblOutFileN = new System.Windows.Forms.Label();
            this.chk_debug = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // btnReadText
            // 
            this.btnReadText.Location = new System.Drawing.Point(12, 12);
            this.btnReadText.Name = "btnReadText";
            this.btnReadText.Size = new System.Drawing.Size(75, 23);
            this.btnReadText.TabIndex = 0;
            this.btnReadText.Text = "Read Text";
            this.btnReadText.UseVisualStyleBackColor = true;
            this.btnReadText.Click += new System.EventHandler(this.btnReadText_Click);
            // 
            // lblStatus
            // 
            this.lblStatus.AutoSize = true;
            this.lblStatus.Location = new System.Drawing.Point(93, 17);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(0, 13);
            this.lblStatus.TabIndex = 1;
            // 
            // rtLyrics
            // 
            this.rtLyrics.Location = new System.Drawing.Point(12, 110);
            this.rtLyrics.Name = "rtLyrics";
            this.rtLyrics.Size = new System.Drawing.Size(658, 240);
            this.rtLyrics.TabIndex = 2;
            this.rtLyrics.Text = "";
            // 
            // lblConfidence
            // 
            this.lblConfidence.AutoSize = true;
            this.lblConfidence.Location = new System.Drawing.Point(12, 38);
            this.lblConfidence.Name = "lblConfidence";
            this.lblConfidence.Size = new System.Drawing.Size(67, 13);
            this.lblConfidence.TabIndex = 3;
            this.lblConfidence.Text = "Confidence: ";
            // 
            // rtMatched
            // 
            this.rtMatched.Location = new System.Drawing.Point(12, 54);
            this.rtMatched.Name = "rtMatched";
            this.rtMatched.Size = new System.Drawing.Size(658, 50);
            this.rtMatched.TabIndex = 4;
            this.rtMatched.Text = "";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 414);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(42, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Results";
            // 
            // Label5
            // 
            this.Label5.AutoSize = true;
            this.Label5.Location = new System.Drawing.Point(12, 446);
            this.Label5.Name = "Label5";
            this.Label5.Size = new System.Drawing.Size(49, 13);
            this.Label5.TabIndex = 6;
            this.Label5.Text = "Evilness:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 465);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(44, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "Genres:";
            // 
            // lblGenre
            // 
            this.lblGenre.AutoSize = true;
            this.lblGenre.Location = new System.Drawing.Point(67, 465);
            this.lblGenre.Name = "lblGenre";
            this.lblGenre.Size = new System.Drawing.Size(33, 13);
            this.lblGenre.TabIndex = 8;
            this.lblGenre.Text = "None";
            // 
            // lblEvilness
            // 
            this.lblEvilness.AutoSize = true;
            this.lblEvilness.Location = new System.Drawing.Point(67, 446);
            this.lblEvilness.Name = "lblEvilness";
            this.lblEvilness.Size = new System.Drawing.Size(28, 13);
            this.lblEvilness.TabIndex = 9;
            this.lblEvilness.Text = "0.00";
            // 
            // lblMsg
            // 
            this.lblMsg.AutoSize = true;
            this.lblMsg.Location = new System.Drawing.Point(12, 355);
            this.lblMsg.Name = "lblMsg";
            this.lblMsg.Size = new System.Drawing.Size(0, 13);
            this.lblMsg.TabIndex = 10;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 484);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(47, 13);
            this.label3.TabIndex = 11;
            this.label3.Text = "Number:";
            // 
            // lblOutFileN
            // 
            this.lblOutFileN.AutoSize = true;
            this.lblOutFileN.Location = new System.Drawing.Point(67, 484);
            this.lblOutFileN.Name = "lblOutFileN";
            this.lblOutFileN.Size = new System.Drawing.Size(13, 13);
            this.lblOutFileN.TabIndex = 12;
            this.lblOutFileN.Text = "0";
            // 
            // chk_debug
            // 
            this.chk_debug.AutoSize = true;
            this.chk_debug.Location = new System.Drawing.Point(99, 17);
            this.chk_debug.Name = "chk_debug";
            this.chk_debug.Size = new System.Drawing.Size(102, 17);
            this.chk_debug.TabIndex = 13;
            this.chk_debug.Text = "No phone mode";
            this.chk_debug.UseVisualStyleBackColor = true;
            // 
            // ControlCenter
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(680, 649);
            this.Controls.Add(this.chk_debug);
            this.Controls.Add(this.lblOutFileN);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.lblMsg);
            this.Controls.Add(this.lblEvilness);
            this.Controls.Add(this.lblGenre);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.Label5);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.rtMatched);
            this.Controls.Add(this.lblConfidence);
            this.Controls.Add(this.rtLyrics);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.btnReadText);
            this.Name = "ControlCenter";
            this.Text = "ControlCenter";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnReadText;
        private System.Windows.Forms.Label lblStatus;
        private System.Windows.Forms.RichTextBox rtLyrics;
        private System.Windows.Forms.Label lblConfidence;
        private System.Windows.Forms.RichTextBox rtMatched;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label Label5;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label lblGenre;
        private System.Windows.Forms.Label lblEvilness;
        private System.Windows.Forms.Label lblMsg;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label lblOutFileN;
        private System.Windows.Forms.CheckBox chk_debug;
    }
}

