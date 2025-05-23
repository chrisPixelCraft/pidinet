for category in top5underwear top5acc top5shoe top5gfb top5glb top5gub; do
  for week in /root/pidinet/top5/$category/*; do
    # Use a new base name for the output directory, e.g., prefix 'processed_'
    new_basename="processed_$(basename $week)"
    outdir="/root/pidinet/results/$category/$new_basename"
    mkdir -p "$outdir"  # Ensure the output directory exists

    # Count images (jpg/png/jpeg) in the week folder
    img_count=$(find "$week" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | wc -l)

    if [ "$img_count" -eq 0 ]; then
      echo "No images found in $week" > "$outdir/README.txt"
    else
      python main.py --model pidinet_converted --config carv4 --sa --dil -j 4 --gpu 0 \
        --savedir "$outdir" \
        --datadir "$week" \
        --dataset Custom \
        --evaluate /root/pidinet/trained_models/table5_pidinet.pth \
        --evaluate-converted
    fi
  done
done