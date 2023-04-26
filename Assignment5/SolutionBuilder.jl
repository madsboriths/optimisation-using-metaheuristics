### SolutionBuilder

using Random

# Destroy a percentage of elements from a random production line
function destroyPercentage(initSol, initRevenue, initManufacturingTimes, initRemainingProducts, dim, rev, rev_pair, k, H, p)
    percentage = rand([0.05, 0.10, 0.15, 0.20, 0.50])
    productionLine = rand(1:k)
    numOfElements = length(initSol[productionLine])
    elementsToRemove = round(Int, numOfElements * percentage)  
    
    sol = deepcopy(initSol)
    revenue = initRevenue
    manufacturingTimes = deepcopy(initManufacturingTimes)
    remainingProducts = deepcopy(initRemainingProducts)

    # Remove percentage of elements from production line
    for i in 1:elementsToRemove
        element = rand(sol[productionLine])
        manufacturingTimes[productionLine] -= p[element]
        filter!(x -> x != element, sol[productionLine])
        push!(remainingProducts, element)
        for j in sol[productionLine]
            revenue -= rev_pair[j, element]
        end
        revenue -= rev[element]
    end
    return sol, revenue, manufacturingTimes, remainingProducts
end

# Remove fixed number of elements from all production lines
function destroyPercentageAllProductionLines(initSol, initRevenue, initManufacturingTimes, initRemainingProducts, dim, rev, rev_pair, k, H, p)
    percentage = rand([0.05, 0.10, 0.15, 0.20, 0.50])

    sol = deepcopy(initSol)
    revenue = initRevenue
    manufacturingTimes = deepcopy(initManufacturingTimes)
    remainingProducts = deepcopy(initRemainingProducts)

    # Iterate over all production lines
    for i in 1:k
        # Find number of elements to remove
        elementsToRemove = round(Int, length(sol[i]) * percentage)  

        # Remove elements
        for j in 1:elementsToRemove
            element = rand(sol[i])
            manufacturingTimes[i] -= p[element]
            filter!(x -> x != element, sol[i])
            push!(remainingProducts, element)
            for j in sol[i]
                revenue -= rev_pair[j, element]
            end
            revenue -= rev[element]
        end
    end
    return sol, revenue, manufacturingTimes, remainingProducts
end

# For some random production line: Remove element that provides the least amount of total revenue + the bonus of elements in the same production line
function destroyElementWithLeastRevenue(initSol, initRevenue, initManufacturingTimes, initRemainingProducts, dim, rev, rev_pair, k, H, p)
    percentage = rand([0.05, 0.10, 0.15, 0.20, 0.50])
    numOfElementsToRemove = round(Int, dim * percentage)
    
    sol = deepcopy(initSol)
    revenue = initRevenue
    manufacturingTimes = deepcopy(initManufacturingTimes)
    remainingProducts = deepcopy(initRemainingProducts)

    # Do the code below a number of times in a for loop
    for i in 1:numOfElementsToRemove
        # Find production line
        productionLine = rand(1:k)

        if (length(sol[productionLine]) == 0)
            continue
        end

        # Find element with least revenue
        min = Inf
        minIdx = 0
        for i in sol[productionLine]
            revenueGain = rev[i]
            for j in sol[productionLine]
                revenueGain += rev_pair[j, i]
            end
            if (revenueGain < min)
                min = revenueGain
                minIdx = i
            end
        end

        # Remove element
        manufacturingTimes[productionLine] -= p[minIdx]
        filter!(x -> x != minIdx, sol[productionLine])
        push!(remainingProducts, minIdx)
        for j in sol[productionLine]
            revenue -= rev_pair[j, minIdx]
        end
        revenue -= rev[minIdx]
    end
    return sol, revenue, manufacturingTimes, remainingProducts
end

function repairRandom(initSol, initRevenue, initManufacturingTimes, initRemainingProducts, dim, rev, rev_pair, k, H, p)
    sol = deepcopy(initSol)
    revenue = initRevenue
    manufacturingTimes = deepcopy(initManufacturingTimes)
    remainingProducts = deepcopy(initRemainingProducts)

    productionLineOrder = [i for i in 1:k]
    shuffle!(productionLineOrder)
    
    while(length(remainingProducts) > 0)
        found = false
        for productionLine in productionLineOrder
            for remainingProduct in remainingProducts
                if (manufacturingTimes[productionLine] + p[remainingProduct] <= H)
                    found = true

                    # Update available time
                    manufacturingTimes[productionLine] += p[remainingProduct]
                    
                    # Update solution
                    push!(sol[productionLine], remainingProduct)
                    filter!(x -> x != remainingProduct, remainingProducts)

                    # Update revenue
                    for j in sol[productionLine]
                        revenue += rev_pair[j, remainingProduct]
                    end
                    revenue += rev[remainingProduct]
                end
            end
        end
        if (!found)
            break
        end
    end
    return sol, revenue, manufacturingTimes, remainingProducts
end

function repairBestInsert(initSol, initRevenue, initManufacturingTimes, initRemainingProducts, dim, rev, rev_pair, k, H, p)
    sol = deepcopy(initSol)
    revenue = initRevenue
    manufacturingTimes = deepcopy(initManufacturingTimes)
    remainingProducts = deepcopy(initRemainingProducts)
    
    while(length(remainingProducts) > 0)
        bestProductionLine = 0
        bestRemainingProduct = 0
        bestRevenue = -Inf

        full = true
        for productionLine in 1:k
            for remainingProduct in remainingProducts
                if (manufacturingTimes[productionLine] + p[remainingProduct] <= H)
                    full = false

                    # Calculate total revenueGain from inserting this product here:
                    revenueGain = rev[remainingProduct]
                    for j in sol[productionLine]
                        revenueGain += rev_pair[j, remainingProduct]
                    end

                    if (revenueGain > bestRevenue)
                        bestRevenue = revenueGain
                        bestProductionLine = productionLine
                        bestRemainingProduct = remainingProduct
                    end
                end
            end
        end
        if (full)
            break
        end
        # Update available time
        manufacturingTimes[bestProductionLine] += p[bestRemainingProduct]
                        
        # Update solution
        push!(sol[bestProductionLine], bestRemainingProduct)
        filter!(x -> x != bestRemainingProduct, remainingProducts)
    
        # Update revenue
        for j in sol[bestProductionLine]
            revenue += rev_pair[j, bestRemainingProduct]
        end
        revenue += rev[bestRemainingProduct]
    end
    return sol, revenue, manufacturingTimes, remainingProducts
end