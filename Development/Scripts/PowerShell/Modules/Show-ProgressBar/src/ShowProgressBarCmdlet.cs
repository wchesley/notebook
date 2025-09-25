using System;
using System.Management.Automation;
using System.Text;

// The namespace should match your C# project name.
namespace ProgressBar
{
    /// <summary>
    /// <para type="synopsis">
    /// Generates a string for a high-resolution progress bar using Unicode Braille patterns.
    /// </para>
    /// <para type="description">
    /// This cmdlet creates a progress bar string similar to the one used in Docker's
    /// terminal interface. It calculates the appropriate number of full and partial
    /// Braille characters to represent the given progress percentage across a specified width.
    /// </para>
    /// <para type="example">
    ///   <code>Get-BrailleProgressBar -Progress 0.75 -Width 50</code>
    ///   <para>Generates a 50-character wide progress bar at 75% completion.</para>
    /// </para>
    /// <para type="example">
    ///   <code>0..100 | ForEach-Object { Get-BrailleProgressBar -Progress ($_ / 100.0) }</code>
    ///   <para>Demonstrates the progress bar animating from 0% to 100%.</para>
    /// </para>
    /// </summary>
    [Cmdlet(VerbsCommon.Get, "BrailleProgressBar")]
    [OutputType(typeof(string))]
    public class ShowProgressBarCmdlet : PSCmdlet
    {
        #region Character Constants
        private const char FullBlock = '⣿';
        private static readonly char[] PartialBlocks = { '⡀', '⡄', '⡆', '⡇', '⣇', '⣧', '⣷' };
        #endregion

        #region Parameters
        /// <summary>
        /// <para type="description">
        /// The progress value, represented as a double between 0.0 (empty) and 1.0 (full).
        /// This parameter accepts pipeline input.
        /// </para>
        /// </summary>
        [Parameter(
            Mandatory = true,
            Position = 0,
            ValueFromPipeline = true,
            HelpMessage = "Progress as a value from 0.0 to 1.0.")]
        [ValidateRange(0.0, 1.0)]
        public double Progress { get; set; }

        /// <summary>
        /// <para type="description">
        /// The total character width of the progress bar, excluding the brackets.
        /// </para>
        /// </summary>
        [Parameter(
            Position = 1,
            HelpMessage = "The total character width of the progress bar.")]
        public int Width { get; set; } = 40;
        #endregion

        #region Cmdlet Overrides
        /// <summary>
        /// The main processing logic for the cmdlet.
        /// </summary>
        protected override void ProcessRecord()
        {
            // 1. Calculate the total number of discrete "sub-steps" (8 per character cell)
            long totalSubsteps = (long)Width * 8;
            long filledSubsteps = (long)Math.Round(Progress * totalSubsteps);

            // 2. Determine the number of full blocks and the partial block's state
            long numFullBlocks = filledSubsteps / 8;
            long numPartialSteps = filledSubsteps % 8;

            // 3. Build the bar string using StringBuilder for efficiency
            var barBuilder = new StringBuilder(Width);

            // Append the full blocks
            for (int i = 0; i < numFullBlocks; i++)
            {
                barBuilder.Append(FullBlock);
            }

            // Append the final partial block if needed
            if (numPartialSteps > 0 && numFullBlocks < Width)
            {
                // Array is 0-indexed, but our steps are 1-7
                barBuilder.Append(PartialBlocks[numPartialSteps - 1]);
            }

            // 4. Pad the bar to the correct width and add brackets
            string paddedBar = barBuilder.ToString().PadRight(Width);
            string finalBar = $"[{paddedBar}]";

            // 5. Write the final string to the PowerShell pipeline
            WriteObject(finalBar);
        }
        #endregion
    }
}