$(document).ready(()=> {
    let toggle = true
    let count = 0
    let count2 = 0

    const array = [
        [25, 1, 12, 'tjugofem'],
        [30, 1, 9.5, 'trettio'],
        [75, 1, 67, 'sjuttiofem'],
        [100, 1, 213 , 'etthundra'],
        [150, 1, 1600, 'etthundra'],
        [200, 1, 4444, 'tvåhundra'],
        [250, 1, 4000, 'tvåhundrafemtio'],
        [500, 1, 10000, 'femhundra'],
        [750, 1, 13333, 'sjuhunrafemtio'],
        [1000, 1, 9524, 'etttusen'],
        [2000, 1, 14285, 'tvåtusen'],
        [10000, 1, 50000, 'tiotusen']
    ]

    const multiplyer = [
        [2, 1, 20],
        [10, 1, 100]
    ]
    
    const play = ()=> {
        multiplyer.forEach((elem)=> {
        const random = Math.floor((Math.random() * (Math.ceil(elem[2]))))
        if (random === 1) {
            // console.log(elem[0])
            $('#multiplyer').html(elem[0])
        } else {
            count2++
            if (count2 === multiplyer.length) {
                $('#multiplyer').html('1')
            }
        }
    })

    array.forEach((element)=> {
        const random = (Math.floor(Math.random() * (Math.ceil(element[2]) - Math.ceil(element[1])) + Math.ceil(element[1])))
        if (random === 1 && toggle === true) {
            win(element[0], element[3])
            toggle = false
            return toggle
        } else {
            count++
            if (count === array.length) {
                lose()
            }
        }
        return toggle
    })
    return toggle
}

    const lose = ()=> {
        let array2 = [
            [25, 1, 12, 'tjugofem'],
            [30, 1, 9.5, 'trettio'],
            [75, 1, 67, 'sjuttiofem'],
            [100, 1, 213 , 'etthundra'],
            [150, 1, 1600, 'etthundra'],
            [200, 1, 4444, 'tvåhundra'],
            [250, 1, 4000, 'tvåhundrafemtio'],
            [500, 1, 10000, 'femhundra'],
            [750, 1, 13333, 'sjuhunrafemtio'],
            [1000, 1, 9524, 'etttusen'],
            [2000, 1, 14285, 'tvåtusen'],
            [10000, 1, 50000, 'tiotusen'],
            [25, 1, 12, 'tjugofem'],
            [30, 1, 9.5, 'trettio'],
            [75, 1, 67, 'sjuttiofem'],
            [100, 1, 213 , 'etthundra'],
            [150, 1, 1600, 'etthundra'],
            [200, 1, 4444, 'tvåhundra'],
            [250, 1, 4000, 'tvåhundrafemtio'],
            [500, 1, 10000, 'femhundra'],
            [750, 1, 13333, 'sjuhunrafemtio'],
            [1000, 1, 9524, 'etttusen'],
            [2000, 1, 14285, 'tvåtusen'],
            [10000, 1, 50000, 'tiotusen']
        ]
        
        let finalArray = array2.sort(() => Math.random() - 0.5).slice(0,9)
        finalArray.forEach((elem)=> {
            $('#number').append(`<div class="trissnummer"><div class="nummer">${elem[0]}</div><div class="nummer-name">${elem[3]}</div></div>`)
        })

        let array4 = multiplyer.sort(() => Math.random() - 0.5)
        $('#multiplyer').html('')
        $('#multiplyer').html(array4[0][0])
        // console.log('lose')
        
    }


    const win = (p1, p2)=> {
        let winNum = p1
        
        let dummyArray = [
            [winNum, 0, 0, p2],
            [winNum, 0, 0, p2],
            [winNum, 0, 0, p2]
        ]

        let array2 = [
            [25, 1, 12, 'tjugofem'],
            [30, 1, 9.5, 'trettio'],
            [75, 1, 67, 'sjuttiofem'],
            [100, 1, 213 , 'etthundra'],
            [150, 1, 1600, 'etthundra'],
            [200, 1, 4444, 'tvåhundra'],
            [250, 1, 4000, 'tvåhundrafemtio'],
            [500, 1, 10000, 'femhundra'],
            [750, 1, 13333, 'sjuhunrafemtio'],
            [1000, 1, 9524, 'etttusen'],
            [2000, 1, 14285, 'tvåtusen'],
            [10000, 1, 50000, 'tiotusen'],
            [25, 1, 12, 'tjugofem'],
            [30, 1, 9.5, 'trettio'],
            [75, 1, 67, 'sjuttiofem'],
            [100, 1, 213 , 'etthundra'],
            [150, 1, 1600, 'etthundra'],
            [200, 1, 4444, 'tvåhundra'],
            [250, 1, 4000, 'tvåhundrafemtio'],
            [500, 1, 10000, 'femhundra'],
            [750, 1, 13333, 'sjuhunrafemtio'],
            [1000, 1, 9524, 'etttusen'],
            [2000, 1, 14285, 'tvåtusen'],
            [10000, 1, 50000, 'tiotusen']
        ]

        let array3 = []

        array2.forEach((e)=> {
            if (e == winNum) {
            } else {
                array3.push(e)
                return array3
            }
            return array3
        })

        let newArray = dummyArray.concat(array3.sort(() => Math.random() - 0.5).slice(0,6))
        let finalArray = newArray.sort(() => Math.random() - 0.5)
        finalArray.forEach((elem)=> {
            $('#number').append(`<div class="trissnummer"><div class="nummer">${elem[0]}</div><div class="nummer-name">${elem[3]}</div></div>`)
        })

        // console.log(`You win ${Number($('#multiplyer').html()) * winNum}`)
        emit_client_event("altrix_scratchoff:payment", { ["amount"] : Number($('#multiplyer').html()) * winNum })
    }

    emit_client_event = (event, data) => {
        const pipe = {
            event: event,
            data: data
        }

        // console.log("Trigger client event: " + event)

        $.post("http://nuipipe/nui_client_response", JSON.stringify(pipe))
    };

    window.addEventListener("message", (event) => {
		switch (event.data["Operation"]) {
			case "OPEN_SCRATCHOFF": {
				play()

                $("body").fadeIn()

				break;
			}
			case "CLOSE_SCRATCHOFF": {
                $("body").fadeOut()

				break;
            }
            default: {
                // console.log(event.data["Operation"] + " does not exist")

                break;
            }
		}
	});
})
